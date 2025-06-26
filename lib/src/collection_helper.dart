import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

///A [CollectionHelper] is a class that helps you manage a specific collection.
///To see what a [CollectionHelper] can do, take a look at its methods.
///[CollectionHelper] expects the following arguments:
/// - pb: the pocketbase instance of your application
/// - collection: the collection this helper operates on
/// - mapper: a function that converts `Map<String, dynamic>` to your model
class CollectionHelper<T extends PocketBaseRecord> {
  CollectionHelper(this.pb, {required this.collection, required this.mapper})
    : _helper = BaseHelper(pb);

  ///The collection this collection helper operates on
  final String collection;

  ///The mapper that converts a json/map into one of your models
  final RecordMapper<T> mapper;

  ///The pocketbase instance
  final PocketBase pb;

  final BaseHelper _helper;

  ///Execute a search on records based on requested table data.
  ///Takes `TableParams` and constructs a `TableResult` based on these params.
  ///Internally this method contructs and advanced filter, that keyword searches all the [searchableColumns]
  ///for the query provides in [params].
  ///
  ///If commas are present in this query the query will be comma seperated into multiple keywords
  ///that will all be present in the filter.
  ///
  ///This method was designed with tables in mind and is especially to make ui tables with searchbars
  Future<TableResult<T>> getTabled({
    required TableParams params,
    required List<String> searchableColumns,
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getTabled(
    collection,
    params: params,
    searchableColumns: searchableColumns,
    mapper: mapper,
    otherFilters: otherFilters,
    otherParams: otherParams,
    query: query,
    headers: headers,
  );

  ///Get a paginated list from a collection, `expr` and `params` fields can be optionally supplied to filter the result
  Future<TableResult<T>> getList({
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    bool skipTotal = false,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getList(
    collection,
    mapper: mapper,
    expr: expr,
    params: params,
    page: page,
    perPage: perPage,
    skipTotal: false,
    sort: sort,
    query: query,
    headers: headers,
  );

  ///Get a full list from a collection, `expr` and `params` fields can be optionally supplied to filter the result
  Future<List<T>> getFullList({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getFullList(
    collection,
    mapper: mapper,
    expr: expr,
    params: params,
    sort: sort,
    query: query,
    headers: headers,
  );

  ///Get a single record from a collection by its id
  Future<T> getSingle(
    String id, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.getSingle(
    collection,
    id: id,
    mapper: mapper,
    query: query,
    headers: headers,
  );

  ///Create a new record from the `data` argument
  Future<T> create({
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.create(
    collection,
    data: data,
    mapper: mapper,
    query: query,
    headers: headers,
  );

  ///Update the supplied record, effectively this syncs the record that is supplied the database
  Future<T> update(
    T record, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.update(
    collection,
    record: record,
    mapper: mapper,
    query: query,
    headers: headers,
  );

  ///Delete a record by its id
  Future<void> delete(
    String id, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.delete(collection, id: id, query: query, headers: headers);

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
    required List<String> filePaths,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.addFiles(
    collection,
    id: id,
    filePaths: filePaths,
    mapper: mapper,
    query: query,
    headers: headers,
  );

  ///Remove files from a record, this takes:
  /// - The id of the record the files will belong too
  /// - the file urls pointing to where the files are stored on the pocketbase instance (they can also be just the filenames)
  Future<T> removeFiles(
    String id, {
    required List<String> fileUrls,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) => _helper.removeFiles(
    collection,
    id: id,
    fileUrls: fileUrls,
    mapper: mapper,
    query: query,
    headers: headers,
  );
}
