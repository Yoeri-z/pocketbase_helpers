///A function that maps a record to an object
typedef RecordMapper<T extends Object> = T Function(Map<String, dynamic> map);

///A typed version of pocketbases [ResultList]
class TypedResultList<T> {
  ///Constructs a typed version of pocketbases [ResultList]
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

///The baseclass for all models that represent a pocketbase record.
///Extend your models with this class to use [CollectionHelper]s
///models, should be immutable
abstract interface class PocketBaseRecord {
  ///The baseclass for all models that represent a pocketbase record.
  ///Extend your models with this class to use [CollectionHelper]s
  ///models, should be immutable
  const PocketBaseRecord();

  ///The id of this record
  String get id;

  ///A mapper method mapping this object to a map
  ///if your model has a [toJson] method instead, you can implement toMap like this:
  ///```
  ///@override
  ///Map<String, dynamic> toMap() => toJson();
  ///```
  ///
  ///This naming was chosen because the method converts the object into a dart map, so it is more correct.
  Map<String, dynamic> toMap();
}

/// Result of an authentication process.
enum AuthResult {
  ///The authentication was succesfull.
  ok,

  /// The authentication failed because the request was rejected by the server.
  incorrectCredentials,

  tooManyOtpRequests,

  /// The authentication failed because the server could not be reached or had an internal error.
  serverError,
}
