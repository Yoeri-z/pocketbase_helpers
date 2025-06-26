///Search paramaters to be used when running search queries
///This class bundles all common parameters for more advanced list queries
///the [query] fields is a string query which is used to keyword search a collection.
///This query can also be comma seperated.
///
///For example, if query="alice, writer", it will return all records that contain the words alice and writer.
class SearchParams {
  const SearchParams({
    this.query,
    this.sortColumn,
    this.ascending = false,
    this.page = 1,
    this.perPage = 30,
  });

  ///a string query which is used to keyword search a collection.
  ///For example, if query="alice, writer", it will return all records that contain the words alice and writer.
  final String? query;

  ///The column that the result may be sorted on
  ///if you want more custom sort orders, use the [helper.getList] method and [HelperUtils.buildQuery] method to
  ///contruct your own search function
  final String? sortColumn;

  ///Wether or not the result should be sorted ascending or descending
  final bool ascending;

  ///The page to be returned
  final int page;

  ///The amount of records per page
  final int perPage;

  ///Copy the current searchparams with new values if supplied
  SearchParams copyWith({
    String? query,
    String? sortColumn,
    bool? ascending,
    int? page,
    int? perPage,
  }) {
    return SearchParams(
      query: query ?? this.query,
      sortColumn: sortColumn ?? this.sortColumn,
      ascending: ascending ?? this.ascending,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}

///A typed version of pocketbases [ResultList]
class TypedResultList<T> {
  const TypedResultList(
    this.items, {
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  final List<T> items;
  final int perPage;
  final int page;
  final int totalItems;
  final int totalPages;
}
