import 'dart:typed_data';

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

    final result = await pb
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
      result.items
          .map(
            (record) => mapper(
              HelperUtils.mergeExpansions(expansions, record.toJson()).clean(),
            ),
          )
          .toList(),
      page: result.page,
      perPage: result.perPage,
      totalItems: result.totalItems,
      totalPages: result.totalPages,
    );
  }

  ///Get a paginated list from a collection, `expr` and `params` fields can be optionally supplied to filter the result
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

    final result = await pb
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
      result.items
          .map(
            (record) => mapper(
              HelperUtils.mergeExpansions(expansions, record.toJson()).clean(),
            ),
          )
          .toList(),
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
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }
    final result = await pb
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

    return result
        .map(
          (record) => mapper(
            HelperUtils.mergeExpansions(expansions, record.toJson()).clean(),
          ),
        )
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
    final result = await pb
        .collection(collection)
        .getOne(
          id,
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );
    return mapper(
      HelperUtils.mergeExpansions(expansions, result.toJson()).clean(),
    );
  }

  ///Get multiple records from a collection by their ids.
  Future<List<T>> getMultiple<T extends Object>(
    String collection, {
    required Iterable<String> ids,
    required RecordMapper<T> mapper,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => [for (final id in ids) getOne(collection, id: id, mapper: mapper)].wait;

  ///Get a single record from a collection by its id,
  ///if it is not available this returns null
  Future<T?> getOneOrNull<T extends Object>(
    String collection, {
    required RecordMapper<T> mapper,
    String? expr,
    Map<String, String>? params,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String? filter;
    if (expr != null) {
      filter = pb.filter(expr, params ?? const {});
    }

    final result = await pb
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

    if (result.items.isEmpty) {
      return null;
    } else {
      return mapper(
        HelperUtils.mergeExpansions(
          expansions,
          result.items.first.toJson(),
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

    final result = await pb
        .collection(collection)
        .getList(
          page: 1,
          perPage: 1,
          filter: filter,
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return result.totalItems;
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
          body: HelperUtils.preCreationHook(collection, pb, data),
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(
      HelperUtils.mergeExpansions(expansions, record.toJson()).clean(),
    );
  }

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update<T extends PocketBaseRecord>(
    String collection, {
    required T record,
    required RecordMapper<T> mapper,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb
        .collection(collection)
        .update(
          record.id,
          body: HelperUtils.preUpdateHook(collection, pb, record.toMap()),
          expand: HelperUtils.buildExpansionString(expansions),
          fields: fields?.join(','),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return mapper(
      HelperUtils.mergeExpansions(expansions, result.toJson()).clean(),
    );
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

  ///Returns a helper to help operate on files in a record.
  FileHelper fileField<T extends PocketBaseRecord>(
    String collection, {
    required String id,
    required String field,
    required RecordMapper mapper,
    Map<String, String>? expansions,
  }) {
    return FileHelper(
      collection: collection,
      pb: pb,
      id: id,
      field: field,
      mapper: mapper,
      expansions: expansions,
    );
  }
}

///A helper to do operations on files.
class FileHelper<T extends Object> {
  ///A helper to do operations on files.
  const FileHelper({
    required PocketBase pb,
    required this.collection,
    required this.id,
    required this.field,
    required RecordMapper<T> mapper,
    Map<String, String>? expansions,
  }) : _pb = pb,
       _mapper = mapper,
       _expansions = expansions;

  final PocketBase _pb;
  final RecordMapper<T> _mapper;
  final Map<String, String>? _expansions;

  ///The collection this helper is operating on.
  final String collection;

  ///The id of the record this helper is operating on.
  final String id;

  ///The file field this helper is operating on
  final String field;

  ///Set a single file in the field.
  Future<T> set(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          files: [MultipartFile.fromBytes(field, fileData, filename: fileName)],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Sets the file field to be empty.
  ///
  ///Only works on fields that do not support multiple files.
  ///If you want to clear all files on a multi file field, use [removeAll] instead.
  Future<T> unset({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          body: {field: null},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Add a file to the field, only works if the field supports multiple files.
  Future<T> add(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          files: [
            MultipartFile.fromBytes('$field+', fileData, filename: fileName),
          ],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Add multiple files to the field, only works if the fieldSupports multiple files.
  Future<T> addMany(
    Map<String, Uint8List> files, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          files: [
            for (final entry in files.entries)
              MultipartFile.fromBytes(
                '$field+',
                entry.value,
                filename: entry.key,
              ),
          ],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Remove a file from the field, only works if the field supports multiple files.
  Future<T> remove(
    String fileName, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          body: {
            '$field-': [fileName],
          },
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Remove multiple files from the field, only works if the field supports multiple files.
  Future<T> removeMany(
    List<String> names, {
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          body: {'$field-': names},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Remove multiple files from the field, only works if the field supports multiple files.
  ///
  ///If you want to remove the file from a single file field use [unset] instead.
  Future<T> removeAll({
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await _pb
        .collection(collection)
        .update(
          id,
          body: {'$field-': []},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(
      HelperUtils.mergeExpansions(_expansions, record.toJson()).clean(),
    );
  }

  ///Get the absolute file url for a file on this record
  Uri url(String filename) {
    return _pb.buildURL('api/files/$collection/$id/$filename');
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
