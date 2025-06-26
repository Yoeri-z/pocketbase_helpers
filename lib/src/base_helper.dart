import 'dart:io';

import 'package:http/http.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

///A function that maps a record to an object
typedef RecordMapper<T extends Object> = T Function(Map<String, dynamic> map);

///The `BaseHelper` is a (slightly) more low lever version of the `CollectionHelper` and also used by `CollectionHelper` internally
///mainly usefull if your dart model and pocketbase collection do not map one to one or if it does not implement `PocketBaseRecord`
///
///This helper has the same methods as `CollectionHelper` but for each field the collection name and a mapper have to be supplied
class BaseHelper {
  BaseHelper(this.pb);

  ///The pocketbase instance used by this helper
  final PocketBase pb;

  ///Execute a search on records based on requested table data.
  ///Takes `TableParams` and constructs a `TableResult` based on these params.
  ///Internally this method contructs and advanced filter that keyword searches all the [searchableColumns]
  ///for the query provided in [params].
  ///
  ///If commas are present in this query the query will be comma seperated into multiple keywords
  ///that will all be present in the filter.
  ///
  ///This method was designed with tables in mind and is especially to make ui tables with searchbars.
  ///Also works nice with flutters paginated table.
  Future<TableResult<T>> getTabled<T extends Object>(
    String collection, {
    required TableParams params,
    required List<String> searchableColumns,
    required RecordMapper<T> mapper,
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (params.query != null || otherFilters != null) {
      final (
        String template,
        Map<String, dynamic> values,
      ) = HelperUtils.buildQuery(
        params.query ?? '',
        searchableColumns,
        otherFilters: otherFilters,
        otherParams: otherParams,
      );

      filter = pb.filter(template, values);
    }

    final result = await pb
        .collection(collection)
        .getList(
          filter: filter,
          sort: HelperUtils.getSortOrderFor(params),
          page: params.page,
          perPage: params.perPage,
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return TableResult(
      result.items.map((record) => mapper(record.toJson().clean())).toList(),
      page: result.page,
      perPage: result.perPage,
      totalItems: result.totalItems,
      totalPages: result.totalPages,
    );
  }

  ///Get a paginated list from a collection, `expr` and `params` fields can be optionally supplied to filter the result
  Future<TableResult<T>> getList<T extends Object>(
    String collection, {
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    bool skipTotal = false,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    late final ResultList<RecordModel> result;
    if (expr != null) {
      result = await pb
          .collection(collection)
          .getList(
            page: page,
            filter: pb.filter(expr, params ?? const {}),
            perPage: perPage,
            skipTotal: skipTotal,
            sort: sort,
            query: query ?? const {},
            headers: headers ?? const {},
          );
    } else {
      result = await pb
          .collection(collection)
          .getList(
            page: page,
            perPage: perPage,
            skipTotal: skipTotal,
            sort: sort,
            query: query ?? const {},
            headers: headers ?? const {},
          );
    }

    return TableResult(
      result.items.map((e) => mapper(e.toJson().clean())).toList(),
      page: result.page,
      perPage: perPage,
      totalItems: result.totalItems,
      totalPages: result.totalPages,
    );
  }

  ///Get a full list from a collection,  `expr` and `params` fields can be optionally supplied to filter the result
  Future<List<T>> getFullList<T extends Object>(
    String collection, {
    int batch = 500,
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    late final List<RecordModel> result;
    if (expr != null) {
      result = await pb
          .collection(collection)
          .getFullList(
            batch: batch,
            filter: pb.filter(expr, params ?? const {}),
            sort: sort,
            query: query ?? const {},
            headers: headers ?? const {},
          );
    } else {
      result = await pb
          .collection(collection)
          .getFullList(
            batch: batch,
            sort: sort,
            query: query ?? const {},
            headers: headers ?? const {},
          );
    }

    return result.map((e) => mapper(e.toJson().clean())).toList();
  }

  ///Get a single record from a collection by its id
  Future<T> getSingle<T extends Object>(
    String collection, {
    required String id,
    required RecordMapper<T> mapper,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb
        .collection(collection)
        .getOne(id, query: query ?? const {}, headers: headers ?? const {});
    return mapper(result.toJson().clean());
  }

  ///Create a new record from the `data` argument
  Future<T> create<T extends Object>(
    String collection, {
    required Map<String, dynamic> data,
    required RecordMapper<T> mapper,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb
        .collection(collection)
        .create(
          body: HelperUtils.creationHook(collection, data),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(result.toJson().clean());
  }

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update<T extends PocketBaseRecord>(
    String collection, {
    required T record,
    required RecordMapper<T> mapper,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb
        .collection(collection)
        .update(
          record.id,
          body: HelperUtils.updateHook(collection, record.toMap()),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(result.toJson().clean());
  }

  ///Delete a record by its id
  Future<void> delete(
    String collection, {
    required String id,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final _ = await pb
        .collection(collection)
        .delete(id, query: query ?? const {}, headers: headers ?? const {});
  }

  ///Get the absolute file url for a file, this function takes
  /// - The collection name
  /// - record id
  /// - filename
  /// and returns a correct Uri that can be used to retrieve it form the database
  Uri getFileUri(String collection, String id, String filename) {
    return pb.buildURL('api/files/$collection/$id/$filename');
  }

  ///Add files to a record, this takes:
  /// - The id of the record the files will belong too
  /// - the filepaths pointing to where the files are stored locally
  Future<T> addFiles<T extends Object>(
    String collection, {
    required String id,
    required List<String> filePaths,
    required RecordMapper<T> mapper,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final files = [for (final filePath in filePaths) File(filePath)];

    final record = await pb
        .collection(collection)
        .update(
          id,
          files: [
            for (final file in files)
              MultipartFile.fromBytes(
                'files+',
                file.readAsBytesSync(),
                filename: file.uri.pathSegments.last,
              ),
          ],
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(record.toJson().clean());
  }

  ///Remove files from a record, this takes:
  /// - The id of the record the files will belong too
  /// - the file urls pointing to where the files are stored on the pocketbase instance (they can also be just the filenames)
  Future<T> removeFiles<T extends Object>(
    String collection, {
    required String id,
    required List<String> fileUrls,
    required RecordMapper<T> mapper,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final names = fileUrls.map((f) => Uri.parse(f).pathSegments.last).toList();
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: {'files-': names},
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(record.toJson().clean());
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
