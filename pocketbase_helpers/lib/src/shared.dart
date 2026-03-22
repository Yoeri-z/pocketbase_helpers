import 'package:pocketbase/pocketbase.dart';

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

enum ChangeAction {
  create,
  update,
  delete,
  unknown;

  factory ChangeAction.fromString(String action) {
    return switch (action) {
      'create' => ChangeAction.create,
      'update' => ChangeAction.update,
      'delete' => ChangeAction.delete,
      _ => ChangeAction.unknown,
    };
  }
}

/// A typed version of [RecordSubscriptionEvent].
/// Contains information related to the firing of a subscription event.
class TypedRecordSubscriptionEvent<T extends Object> {
  /// Create a new [TypedRecordSubscriptionEvent].
  TypedRecordSubscriptionEvent({
    this.action = ChangeAction.unknown,
    this.record,
  });

  /// The action that caused this change.
  final ChangeAction action;

  /// The changed record.
  final T? record;
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
enum AuthStatus {
  ///The authentication was succesfull.
  ok,

  /// The authentication failed because the request was rejected by the server.
  incorrectCredentials,

  tooManyOtpRequests,

  /// The authentication failed because the server could not be reached or had an internal error.
  serverError,
}

/// Typesafe class for the GeoPoint field.
class GeoPoint {
  ///Construct a geopoint.
  const GeoPoint({required this.lon, required this.lat});

  /// The empty geopoint as defined by the pocketbase.io documentation.
  const GeoPoint.empty() : lon = 0.0, lat = 0.0;

  /// The longitude of this point
  final double lon;

  /// The latitude of this point
  final double lat;

  /// Convert this GeoPoint into a map
  Map<String, dynamic> toMap() {
    return {'lon': lon, 'lat': lat};
  }

  @override
  bool operator ==(Object other) {
    return other is GeoPoint && other.lon == lon && other.lat == lat;
  }

  @override
  int get hashCode => Object.hashAll([lon, lat]);

  static GeoPoint fromMap(dynamic map) {
    return GeoPoint(lon: map['lon'] as double, lat: map['lat'] as double);
  }
}
