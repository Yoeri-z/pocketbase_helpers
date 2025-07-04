///A typed version of pocketbases [ResultList]
class TypedResultList<T> {
  const TypedResultList(
    this.items, {
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  ///The items retured by this request
  final List<T> items;

  ///The amount of items per page, if the page is full this is equal to `items.length`
  final int perPage;

  ///The page that this request is from
  final int page;

  ///The total amount of items in the collection
  final int totalItems;

  ///The total amount of pages in the collection
  final int totalPages;
}
