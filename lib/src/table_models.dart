class TableParams {
  const TableParams({
    this.query,
    this.sortColumn,
    this.ascending = false,
    this.page = 1,
    this.perPage = 30,
  });

  final String? query;
  final String? sortColumn;
  final bool ascending;
  final int page;
  final int perPage;

  TableParams copyWith({
    String? query,
    String? sortColumn,
    bool? ascending,
    int? page,
    int? perPage,
  }) {
    return TableParams(
      query: query ?? this.query,
      sortColumn: sortColumn ?? this.sortColumn,
      ascending: ascending ?? this.ascending,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}

class TableResult<T> {
  const TableResult(
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
