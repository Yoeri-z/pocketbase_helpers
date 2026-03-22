// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains custom json serializable models.
// add a `serializables_spec.dart` file next to this file to add imports for the missing types

part of 'serializables_spec.dart';

/// Model for the `users` collection.
class User implements PocketBaseRecord {
  User({
    required this.id,
    required this.email,
    required this.emailVisibility,
    required this.verified,
    this.name,
    this.avatar,
    required this.created,
    required this.updated,
  });

  @override
  final String id;

  final String email;

  final bool emailVisibility;

  final bool verified;

  final String? name;

  final String? avatar;

  final DateTime created;

  final DateTime updated;

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: (map['id'] as String),
      email: (map['email'] as String),
      emailVisibility: (map['emailVisibility'] as bool),
      verified: (map['verified'] as bool),
      name: (map['name'] as String?),
      avatar: (map['avatar'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'emailVisibility': emailVisibility,
        'verified': verified,
        'name': name,
        'avatar': avatar,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  User copyWith({
    String? id,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      created: created,
      updated: updated,
    );
  }

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'users',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          emailVisibility == other.emailVisibility &&
          verified == other.verified &&
          name == other.name &&
          avatar == other.avatar &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        email,
        emailVisibility,
        verified,
        name,
        avatar,
        created,
        updated,
      ]);

  /// Check whether or not the user is authenticated to the `users` collection
  static bool isAuthenticated([PocketBase? pocketBaseInstance]) {
    final pb = pocketBaseInstance ?? PocketBaseConnection.pb;
    return pb.authStore.isValid &&
        pb.authStore.record?.collectionName == 'users';
  }

  /// Returns the currently authenticated `User`.
  /// Throws an assertion error if the user is not authenticated to this collection.
  static User getAuthenticated([PocketBase? pocketBaseInstance]) {
    final pb = pocketBaseInstance ?? PocketBaseConnection.pb;
    assert(
      isAuthenticated(pb),
      'User is not authenticated yet.',
    );
    return fromMap(HelperUtils.getRecordJson(pb.authStore.record!));
  }
}

/// Helper for the `users` collection.
abstract final class Users {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'users';

  ///Gets the [CollectionHelper] for the `users` collection
  static CollectionHelper<User> api([PocketBase? pocketBaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );

  /// Gets the [RealtimeHelper] for the `users` collection
  static RealtimeHelper realtime({
    PocketBase? pb,
    Duration? debounce,
  }) =>
      RealtimeHelper(
        pocketBaseInstance: pb,
        collection: 'users',
        mapper: User.fromMap,
        debounce: debounce,
      );

  ///Gets the [AuthHelper] for the `users` collection
  static AuthHelper<User> auth([PocketBase? pocketBaseInstance]) => AuthHelper(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );

  /// Access the file api for the `avatar` field
  static SingleFileHelper<User> avatarApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<User>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'users',
        id: id,
        field: 'avatar',
        mapper: User.fromMap,
      );
}

/// Model for the `monster_collection` collection.
class MonsterCollection implements PocketBaseRecord {
  MonsterCollection({
    required this.id,
    this.plain,
    required this.plainRequired,
    this.rich,
    required this.richRequired,
    required this.number,
    required this.numberRequired,
    required this.numberNoDecimal,
    required this.boolean,
    this.mail,
    required this.mailNonEmpty,
    this.url,
    required this.urlNonEmpty,
    this.datetime,
    required this.datetimeNonEmpty,
    this.select,
    required this.selectMulti,
    this.file,
    required this.fileMulti,
    required this.fileNonEmpty,
    this.relation,
    required this.relationMulti,
    required this.relationNonEmpty,
    this.json,
    this.items,
    required this.jsonNonEmpty,
    required this.geoPoint,
    required this.created,
    required this.updated,
  });

  @override
  final String id;

  final String? plain;

  final String plainRequired;

  final String? rich;

  final String richRequired;

  final double number;

  final double numberRequired;

  final int numberNoDecimal;

  final bool boolean;

  final String? mail;

  final String mailNonEmpty;

  final String? url;

  final String urlNonEmpty;

  final DateTime? datetime;

  final DateTime datetimeNonEmpty;

  final String? select;

  final List<String> selectMulti;

  final String? file;

  final List<String> fileMulti;

  final String fileNonEmpty;

  final String? relation;

  final List<String> relationMulti;

  final String relationNonEmpty;

  final Json? json;

  final List<Item>? items;

  final JsonNonEmpty jsonNonEmpty;

  final GeoPoint geoPoint;

  final DateTime created;

  final DateTime updated;

  static MonsterCollection fromMap(Map<String, dynamic> map) {
    return MonsterCollection(
      id: (map['id'] as String),
      plain: (map['plain'] as String?),
      plainRequired: (map['plain_required'] as String),
      rich: (map['rich'] as String?),
      richRequired: (map['rich_required'] as String),
      number: (map['number'] as num).toDouble(),
      numberRequired: (map['number_required'] as num).toDouble(),
      numberNoDecimal: (map['number_no_decimal'] as num).toInt(),
      boolean: (map['boolean'] as bool),
      mail: (map['mail'] as String?),
      mailNonEmpty: (map['mail_non_empty'] as String),
      url: (map['url'] as String?),
      urlNonEmpty: (map['url_non_empty'] as String),
      datetime: map['datetime'] != null
          ? DateTime.parse((map['datetime'] as String))
          : null,
      datetimeNonEmpty: DateTime.parse((map['datetime_non_empty'] as String)),
      select: (map['select'] as String?),
      selectMulti: (map['select_multi'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      file: (map['file'] as String?),
      fileMulti: (map['file_multi'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      fileNonEmpty: (map['file_non_empty'] as String),
      relation: (map['relation'] as String?),
      relationMulti: (map['relation_multi'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      relationNonEmpty: (map['relation_non_empty'] as String),
      json: map['json'] != null
          ? Json.fromJson((map['json'] as Map<String, dynamic>))
          : null,
      items: map['items'] != null
          ? (map['items'] as List<dynamic>)
              .map((e) => Item.fromJson((e as Map<String, dynamic>)))
              .toList()
          : null,
      jsonNonEmpty: JsonNonEmpty.fromJson(
          (map['json_non_empty'] as Map<String, dynamic>)),
      geoPoint: GeoPoint.fromMap(map['geo_point']),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'plain': plain,
        'plain_required': plainRequired,
        'rich': rich,
        'rich_required': richRequired,
        'number': number,
        'number_required': numberRequired,
        'number_no_decimal': numberNoDecimal,
        'boolean': boolean,
        'mail': mail,
        'mail_non_empty': mailNonEmpty,
        'url': url,
        'url_non_empty': urlNonEmpty,
        'datetime': datetime?.toIso8601String(),
        'datetime_non_empty': datetimeNonEmpty.toIso8601String(),
        'select': select,
        'select_multi': selectMulti,
        'file': file,
        'file_multi': fileMulti,
        'file_non_empty': fileNonEmpty,
        'relation': relation,
        'relation_multi': relationMulti,
        'relation_non_empty': relationNonEmpty,
        'json': json?.toJson(),
        'items': items?.map((e) => e.toJson()).toList(),
        'json_non_empty': jsonNonEmpty.toJson(),
        'geo_point': geoPoint.toMap(),
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  MonsterCollection copyWith({
    String? id,
    String? plain,
    String? plainRequired,
    String? rich,
    String? richRequired,
    double? number,
    double? numberRequired,
    int? numberNoDecimal,
    bool? boolean,
    String? mail,
    String? mailNonEmpty,
    String? url,
    String? urlNonEmpty,
    DateTime? datetime,
    DateTime? datetimeNonEmpty,
    String? select,
    List<String>? selectMulti,
    String? file,
    List<String>? fileMulti,
    String? fileNonEmpty,
    String? relation,
    List<String>? relationMulti,
    String? relationNonEmpty,
    Json? json,
    List<Item>? items,
    JsonNonEmpty? jsonNonEmpty,
    GeoPoint? geoPoint,
  }) {
    return MonsterCollection(
      id: id ?? this.id,
      plain: plain ?? this.plain,
      plainRequired: plainRequired ?? this.plainRequired,
      rich: rich ?? this.rich,
      richRequired: richRequired ?? this.richRequired,
      number: number ?? this.number,
      numberRequired: numberRequired ?? this.numberRequired,
      numberNoDecimal: numberNoDecimal ?? this.numberNoDecimal,
      boolean: boolean ?? this.boolean,
      mail: mail ?? this.mail,
      mailNonEmpty: mailNonEmpty ?? this.mailNonEmpty,
      url: url ?? this.url,
      urlNonEmpty: urlNonEmpty ?? this.urlNonEmpty,
      datetime: datetime ?? this.datetime,
      datetimeNonEmpty: datetimeNonEmpty ?? this.datetimeNonEmpty,
      select: select ?? this.select,
      selectMulti: selectMulti ?? this.selectMulti,
      file: file ?? this.file,
      fileMulti: fileMulti ?? this.fileMulti,
      fileNonEmpty: fileNonEmpty ?? this.fileNonEmpty,
      relation: relation ?? this.relation,
      relationMulti: relationMulti ?? this.relationMulti,
      relationNonEmpty: relationNonEmpty ?? this.relationNonEmpty,
      json: json ?? this.json,
      items: items ?? this.items,
      jsonNonEmpty: jsonNonEmpty ?? this.jsonNonEmpty,
      geoPoint: geoPoint ?? this.geoPoint,
      created: created,
      updated: updated,
    );
  }

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'monster_collection',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is MonsterCollection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          plain == other.plain &&
          plainRequired == other.plainRequired &&
          rich == other.rich &&
          richRequired == other.richRequired &&
          number == other.number &&
          numberRequired == other.numberRequired &&
          numberNoDecimal == other.numberNoDecimal &&
          boolean == other.boolean &&
          mail == other.mail &&
          mailNonEmpty == other.mailNonEmpty &&
          url == other.url &&
          urlNonEmpty == other.urlNonEmpty &&
          datetime == other.datetime &&
          datetimeNonEmpty == other.datetimeNonEmpty &&
          select == other.select &&
          _listEquals(
            selectMulti,
            other.selectMulti,
          ) &&
          file == other.file &&
          _listEquals(
            fileMulti,
            other.fileMulti,
          ) &&
          fileNonEmpty == other.fileNonEmpty &&
          relation == other.relation &&
          _listEquals(
            relationMulti,
            other.relationMulti,
          ) &&
          relationNonEmpty == other.relationNonEmpty &&
          json == other.json &&
          items == other.items &&
          jsonNonEmpty == other.jsonNonEmpty &&
          geoPoint == other.geoPoint &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        plain,
        plainRequired,
        rich,
        richRequired,
        number,
        numberRequired,
        numberNoDecimal,
        boolean,
        mail,
        mailNonEmpty,
        url,
        urlNonEmpty,
        datetime,
        datetimeNonEmpty,
        select,
        Object.hashAll(selectMulti),
        file,
        Object.hashAll(fileMulti),
        fileNonEmpty,
        relation,
        Object.hashAll(relationMulti),
        relationNonEmpty,
        json,
        items,
        jsonNonEmpty,
        geoPoint,
        created,
        updated,
      ]);
}

/// Helper for the `monster_collection` collection.
abstract final class MonsterCollections {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'monster_collection';

  ///Gets the [CollectionHelper] for the `monster_collection` collection
  static CollectionHelper<MonsterCollection> api(
          [PocketBase? pocketBaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'monster_collection',
        mapper: MonsterCollection.fromMap,
      );

  /// Gets the [RealtimeHelper] for the `monster_collection` collection
  static RealtimeHelper realtime({
    PocketBase? pb,
    Duration? debounce,
  }) =>
      RealtimeHelper(
        pocketBaseInstance: pb,
        collection: 'monster_collection',
        mapper: MonsterCollection.fromMap,
        debounce: debounce,
      );

  /// Access the file api for the `file` field
  static SingleFileHelper<MonsterCollection> fileApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<MonsterCollection>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'monster_collection',
        id: id,
        field: 'file',
        mapper: MonsterCollection.fromMap,
      );

  /// Access the file api for the `file_multi` field
  static MultiFileHelper<MonsterCollection> fileMultiApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<MonsterCollection>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'monster_collection',
        id: id,
        field: 'file_multi',
        mapper: MonsterCollection.fromMap,
      );

  /// Access the file api for the `file_non_empty` field
  static SingleFileHelper<MonsterCollection> fileNonEmptyApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<MonsterCollection>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'monster_collection',
        id: id,
        field: 'file_non_empty',
        mapper: MonsterCollection.fromMap,
      );
}

/// Static class containing all the string literals for your pocketbase collections.
abstract final class Collection {
  /// The name of the `users` collection.
  static const String users = 'users';

  /// The name of the `monster_collection` collection.
  static const String monsterCollections = 'monster_collection';
}

bool _listEquals<T>(
  List<T>? a,
  List<T>? b,
) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index++) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
