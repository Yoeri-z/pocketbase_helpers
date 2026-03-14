import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/pocketbase_connection.dart';

import './shared.dart';
import './helper_utils.dart';

///The `BaseHelper` is a (slightly) more low lever version of the `CollectionHelper` and also used by `CollectionHelper` internally
///mainly usefull if your dart model and pocketbase collection do not map one to one or if it does not implement `PocketBaseRecord`
///
///This helper has the same methods as `CollectionHelper` but for each field the collection name and a mapper have to be supplied
class BaseHelper {
  const BaseHelper({
    PocketBase? pocketBaseInstance,
    this.preCreationHook,
    this.preUpdateHook,
  }) : _pb = pocketBaseInstance;

  final PocketBase? _pb;

  ///The pocketbase instance used by this helper.
  PocketBase get pb => _pb ?? PocketBaseConnection.pb;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on creation
  final HelperHook? preCreationHook;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on updates
  final HelperHook? preUpdateHook;

  ///Execute a search on records based on requested table data.
  ///Takes [SearchParams] and fetches a [TypedResultList].
  ///Internally this method contructs and advanced filter that keyword searches all the [searchableColumns]
  ///for the query provided in [params].
  ///
  ///If commas are present in this query the query will be comma seperated into multiple keywords
  ///that will all be present in the filter.
  ///
  ///This method was designed with tables in mind and is especially to make ui tables with searchbars.
  ///Also works nice with flutters paginated table.
  Future<TypedResultList<T>> search<T extends Object>(
    String collection, {
    required List<String> keywords,
    required List<String> searchableFields,
    required RecordMapper<T> mapper,
    int page = 1,
    int perPage = 30,
    String? sort,
    List<String>? additionalExpressions,
    Map<String, dynamic>? additionalParams,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final (
      String template,
      Map<String, dynamic> values,
    ) = HelperUtils.buildQuery(
      keywords,
      searchableFields,
      otherFilters: additionalExpressions,
      otherParams: additionalParams,
    );

    final filter = pb.filter(template, values);

    final record = await pb
        .collection(collection)
        .getList(
          filter: filter,
          sort: sort,
          page: page,
          perPage: perPage,
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return TypedResultList(
      record.items
          .map(
            (record) => mapper(HelperUtils.getRecordJson(record, expansions)),
          )
          .toList(),
      page: record.page,
      perPage: record.perPage,
      totalItems: record.totalItems,
      totalPages: record.totalPages,
    );
  }

  ///Get a paginated list from a collection, `expr` and `params` fields can be optionally supplied to filter the record
  Future<TypedResultList<T>> getList<T extends Object>(
    String collection, {
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    bool skipTotal = false,
    String? sort,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }

    final record = await pb
        .collection(collection)
        .getList(
          page: page,
          filter: filter,
          perPage: perPage,
          skipTotal: skipTotal,
          expand: HelperUtils.buildExpansionString(expansions),
          sort: sort,
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return TypedResultList(
      record.items
          .map(
            (record) => mapper(HelperUtils.getRecordJson(record, expansions)),
          )
          .toList(),
      page: record.page,
      perPage: record.perPage,
      totalItems: record.totalItems,
      totalPages: record.totalPages,
    );
  }

  ///Get a full list from a collection,  `expr` and `params` fields can be optionally supplied to filter the record
  Future<List<T>> getFullList<T extends Object>(
    String collection, {
    int batch = 500,
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }
    final record = await pb
        .collection(collection)
        .getFullList(
          filter: filter,
          batch: batch,
          sort: sort,
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return record
        .map((record) => mapper(HelperUtils.getRecordJson(record, expansions)))
        .toList();
  }

  ///Get a single record from a collection by its id
  Future<T> getOne<T extends Object>(
    String collection, {
    required String id,
    required RecordMapper<T> mapper,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .getOne(
          id,
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );
    return mapper(HelperUtils.getRecordJson(record, expansions));
  }

  ///Get multiple records from a collection by their ids.
  ///
  ///If [iterative] is true, each record will be fetched by an individual api call.
  Future<List<T>> getMultiple<T extends Object>(
    String collection, {
    required Iterable<String> ids,
    required RecordMapper<T> mapper,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool iterative = false,
  }) async {
    if (ids.isEmpty) return [];

    if (iterative) {
      return [
        for (final id in ids) getOne(collection, id: id, mapper: mapper),
      ].wait;
    }

    final expr = ids.indexed.map((r) => 'id = {:id${r.$1}}').join(' || ');
    final params = {for (final r in ids.indexed) 'id${r.$1}': r.$2};
    final record = await pb
        .collection(collection)
        .getFullList(
          filter: pb.filter(expr, params),
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return record
        .map((record) => mapper(HelperUtils.getRecordJson(record, expansions)))
        .toList();
  }

  ///Get a single record from a collection by an expression,
  ///if  no records match the expression null is returned.
  Future<T?> getOneOrNull<T extends Object>(
    String collection, {
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, dynamic>? params,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }

    final record = await pb
        .collection(collection)
        .getList(
          page: 1,
          perPage: 1,
          filter: filter,
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    if (record.items.isEmpty) {
      return null;
    } else {
      return mapper(
        HelperUtils.mergeExpansions(
          expansions,
          record.items.first.toJson(),
        ).clean(),
      );
    }
  }

  ///Get the count of records that match the provided expression.
  ///If no expression is provided this will return the amount of records in the collection
  Future<int> count(
    String collection, {
    String? expr,
    Map<String, dynamic>? params,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }

    final record = await pb
        .collection(collection)
        .getList(
          page: 1,
          perPage: 1,
          filter: filter,
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return record.totalItems;
  }

  ///Create a new record from the `data` argument
  Future<T> create<T extends Object>(
    String collection, {
    required Map<String, dynamic> data,
    required RecordMapper<T> mapper,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .create(
          body: HelperUtils.preCreationHook(
            collection,
            pb,
            preCreationHook?.call(collection, pb, data) ?? data,
          ),
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(HelperUtils.getRecordJson(record, expansions));
  }

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update<T extends Object>(
    String collection, {
    required String id,
    required Map<String, dynamic> body,
    required RecordMapper<T> mapper,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: HelperUtils.preUpdateHook(
            collection,
            pb,
            preUpdateHook?.call(collection, pb, body) ?? body,
          ),
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(HelperUtils.getRecordJson(record, expansions));
  }

  ///Delete a record by its id
  Future<void> delete(
    String collection, {
    required String id,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final _ = await pb
        .collection(collection)
        .delete(
          id,
          body: body ?? const {},
          query: query ?? const {},
          headers: headers ?? const {},
        );
  }
}

//extension on map to clean up jsons, this avoids unexpected behaviour for nullable fields
//For example a field like `DateTime?` will throw a parse error because pocketbase does empty strings instead of nulls
//clean removes empty strings from the map so they are null
extension _MapClean on Map<String, dynamic> {
  Map<String, dynamic> clean() {
    return HelperUtils.cleanMap(this);
  }
}
