import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

///A [CollectionHelper] is a class that helps you manage a specific collection.
///To see what a [CollectionHelper] can do, take a look at its methods.
///[CollectionHelper] expects the following arguments:
/// - pb: the pocketbase instance of your application
/// - collection: the collection this helper operates on
/// - mapper: a function that converts `Map<String, dynamic>` to your model
class CollectionHelper<T extends PocketBaseRecord> {
  ///A [CollectionHelper] is a class that helps you manage a specific collection.
  ///To see what a [CollectionHelper] can do, take a look at its methods.
  ///[CollectionHelper] expects the following arguments:
  /// - pb: the pocketbase instance of your application
  /// - collection: the collection this helper operates on
  /// - mapper: a function that converts `Map<String, dynamic>` to your model
  CollectionHelper(
    this.pb, {
    required String collection,
    required T Function(Map<String, dynamic>) mapper,
    this.baseExpansions,
  }) : _mapper = mapper,
       collectionName = collection,
       _helper = BaseHelper(pb);

  ///The pocketbase instance
  final PocketBase pb;

  ///The collection this collection helper operates on
  final String collectionName;

  ///The mapper that converts a json/map into one of your models
  final RecordMapper<T> _mapper;

  ///The default expansions to be merged into this record
  ///This is better explained with an example:
  ///```
  ///{
  ///   "post": "WyAw4bDrvws6gGl",
  ///   "user_id": "FtHAW9feB5rze7D",
  ///   "message": "Example message...",
  ///   "expand": {
  ///       "user_id": {
  ///           "name": "John Doe"
  ///           "username": "users54126",
  ///        }
  ///    }
  ///}
  ///```
  ///will get remapped into:
  ///```
  ///{
  ///   "post": "WyAw4bDrvws6gGl",
  ///   "user_id": "FtHAW9feB5rze7D",
  ///   "user": {
  ///        "name": "John Doe"
  ///        "username": "users54126",
  ///      }
  ///   }
  ///   "message": "Example message...",
  ///}
  ///```
  ///when [baseExpansions] is:
  ///```
  ///{
  ///   "user_id" : "user"
  ///}
  ///```
  ///
  ///So now you can put
  ///```
  ///final User user;
  ///```
  ///in your model class
  final Map<String, String>? baseExpansions;

  final BaseHelper _helper;

  ///This is the raw [RecordService] for the collection
  ///(equal to pb.collection(collectionName))
  RecordService get collection => pb.collection(collectionName);

  ///Execute a search on records based on requested table data.
  ///Takes [SearchParams] and fetches a [TypedResultList].
  ///Internally this method contructs and advanced filter, that keyword searches all the [searchableColumns]
  ///for the query provides in [params].
  ///
  ///If commas are present in this query the query will be comma seperated into multiple keywords
  ///that will all be present in the filter.
  ///
  ///This method was designed with tables in mind and is especially to make ui tables with searchbars
  Future<TypedResultList<T>> search({
    required SearchParams params,
    required List<String> searchableColumns,
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.search(
    collectionName,
    params: params,
    searchableColumns: searchableColumns,
    mapper: _mapper,
    otherFilters: otherFilters,
    otherParams: otherParams,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    query: query,
    headers: headers,
  );

  ///Get a paginated list from a collection, [expr] and [params] fields can be optionally supplied to filter the result
  Future<TypedResultList<T>> getList({
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    bool skipTotal = false,
    String? sort,
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getList(
    collectionName,
    mapper: _mapper,
    expr: expr,
    params: params,
    page: page,
    perPage: perPage,
    skipTotal: skipTotal,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    sort: sort,
    query: query,
    headers: headers,
  );

  ///Get a full list from a collection, [expr] and [params] fields can be optionally supplied to filter the result
  Future<List<T>> getFullList({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getFullList(
    collectionName,
    mapper: _mapper,
    expr: expr,
    params: params,
    sort: sort,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    query: query,
    headers: headers,
  );

  ///Get a single record from a collection by its id
  Future<T> getSingle(
    String id, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getSingle(
    collectionName,
    id: id,
    mapper: _mapper,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    query: query,
    headers: headers,
  );

  ///Get a single record from a collection by its id,
  ///returns null if it is not available
  Future<T?> getMaybeSingle(
    String id, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getMaybeSingle(
    collectionName,
    id: id,
    mapper: _mapper,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    query: query,
    headers: headers,
  );

  ///Create a new record from the [data] argument
  Future<T> create({
    required Map<String, dynamic> data,
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.create(
    collectionName,
    data: data,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    mapper: _mapper,
    query: query,
    headers: headers,
  );

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update(
    T record, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.update(
    collectionName,
    record: record,
    mapper: _mapper,
    expansions:
        (baseExpansions ?? {})..addAll(additionalExpansions ?? const {}),
    query: query,
    headers: headers,
  );

  ///Delete a record by its id
  Future<void> delete(
    String id, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.delete(collectionName, id: id, query: query, headers: headers);

  ///Get the absolute file url for a file, this function takes
  /// - record id
  /// - filename
  /// and returns a correct Uri that can be used to retrieve it form the database
  Uri getFileUri(String id, String filename) {
    return pb.buildURL('api/files/$collection/$id/$filename');
  }

  ///Add files to a record, this takes:
  /// - The id of the record the files will belong too
  /// - the filepaths pointing to where the files are stored locally
  Future<T> addFiles(
    String id, {
    required Map<String, Uint8List> files,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.addFiles(
    collectionName,
    id: id,
    files: files,
    mapper: _mapper,
    query: query,
    headers: headers,
  );

  ///Remove files from a record, this takes:
  /// - The id of the record the files will belong too
  /// - the file urls pointing to where the files are stored on the pocketbase instance (they can also be just the filenames)
  Future<T> removeFiles(
    String id, {
    required List<String> fileNames,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.removeFiles(
    collectionName,
    id: id,
    fileNames: fileNames,
    mapper: _mapper,
    query: query,
    headers: headers,
  );
}
