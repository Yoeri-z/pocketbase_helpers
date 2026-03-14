import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/helper_utils.dart';

import './shared.dart';
import './base_helper.dart';

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
  CollectionHelper({
    required String collection,
    required RecordMapper<T> mapper,
    PocketBase? pocketBaseInstance,
    this.preCreationHook,
    this.preUpdateHook,
    this.fields,
    this.expansions,
  }) : _mapper = mapper,
       collectionName = collection,
       _helper = BaseHelper(
         pocketBaseInstance: pocketBaseInstance,
         preCreationHook: preCreationHook,
         preUpdateHook: preUpdateHook,
       );

  ///The pocketbase instance used by this helper.
  PocketBase get pb => _helper.pb;

  ///The collection this collection helper operates on
  final String collectionName;

  ///The mapper that converts a json/map into one of your models
  final RecordMapper<T> _mapper;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on creation
  final HelperHook? preCreationHook;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on updates
  final HelperHook? preUpdateHook;

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
  ///when [expansions] is:
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
  final Map<String, String>? expansions;

  /// The fields the pocketbase request should return.
  ///
  /// Returns all fields if null.
  final List<String>? fields;

  final BaseHelper _helper;

  ///This is the raw [RecordService] for the collection
  ///(equal to pb.collection(collectionName))
  RecordService get collection => pb.collection(collectionName);

  ///Execute a search on records based on requested table data.
  ///Takes [SearchParams] and fetches a [TypedResultList].
  ///Internally this method contructs and advanced filter, that keyword searches all the [searchableFields]
  ///for the query provides in [params].
  ///
  ///If commas are present in this query the query will be comma seperated into multiple keywords
  ///that will all be present in the filter.
  ///
  ///This method was designed with tables in mind and is especially to make ui tables with searchbars
  Future<TypedResultList<T>> search({
    required List<String> keywords,
    required List<String> searchableFields,
    int page = 1,
    int perPage = 30,
    List<String>? additionalExpressions,
    Map<String, dynamic>? additionalParams,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.search(
    collectionName,
    keywords: keywords,
    searchableFields: searchableFields,
    page: page,
    sort: sort,
    perPage: perPage,
    mapper: _mapper,
    additionalExpressions: additionalExpressions,
    additionalParams: additionalParams,
    fields: fields,
    expansions: expansions,
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
    sort: sort,
    expansions: expansions,
    fields: fields,
    query: query,
    headers: headers,
  );

  ///Get a full list from a collection, [expr] and [params] fields can be optionally supplied to filter the result
  Future<List<T>> getFullList({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getFullList(
    collectionName,
    mapper: _mapper,
    expr: expr,
    params: params,
    sort: sort,
    fields: fields,
    expansions: expansions,
    query: query,
    headers: headers,
  );

  ///Get a single record from a collection by its id
  Future<T> getOne(
    String id, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getOne(
    collectionName,
    id: id,
    mapper: _mapper,
    fields: fields,
    expansions: expansions,
    query: query,
    headers: headers,
  );

  ///Get multiple records from a collection by their ids.
  ///
  ///If [iterative] is true, each record will be fetched by an individual api call.
  Future<List<T>> getMultiple(
    Iterable<String> ids, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool iterative = false,
  }) => _helper.getMultiple(
    collectionName,
    ids: ids,
    mapper: _mapper,
    fields: fields,
    expansions: expansions,
    query: query,
    headers: headers,
    iterative: iterative,
  );

  ///Get a single record from a collection by its id,
  ///returns null if it is not available
  Future<T?> getOneOrNull({
    String? expr,
    Map<String, String>? params,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getOneOrNull(
    collectionName,
    expr: expr,
    params: params,
    mapper: _mapper,
    expansions: expansions,
    fields: fields,
    query: query,
    headers: headers,
  );

  ///Get the count of records that match the provided expression.
  ///If no expression is provided this will return the amount of records in the collection
  Future<int> count({
    String? expr,
    Map<String, dynamic>? params,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.count(
    collectionName,
    expr: expr,
    params: params,
    query: query,
    headers: headers,
  );

  ///Create a new record from the [data] argument
  Future<T> create({
    required Map<String, dynamic> data,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.create(
    collectionName,
    data: data,
    expansions: expansions,
    fields: fields,
    mapper: _mapper,
    query: query,
    headers: headers,
  );

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update(
    T record, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.update(
    collectionName,
    id: record.id,
    body: record.toMap(),
    mapper: _mapper,
    expansions: expansions,
    fields: fields,
    query: query,
    headers: headers,
  );

  ///Delete a record by its id
  Future<void> delete(
    String id, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.delete(
    collectionName,
    id: id,
    body: body,
    query: query,
    headers: headers,
  );
}
