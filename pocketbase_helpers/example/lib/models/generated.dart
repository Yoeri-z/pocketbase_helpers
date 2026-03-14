// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

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
  static CollectionHelper<User> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );

  /// Gets the [RealtimeHelper] for the `users` collection
  static RealtimeHelper realtime([
    PocketBase? pocketbaseInstance,
    Duration? debounce,
  ]) =>
      RealtimeHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'users',
        mapper: User.fromMap,
        debounce: debounce,
      );

  ///Gets the [AuthHelper] for the `users` collection
  static AuthHelper<User> auth([PocketBase? pocketbaseInstance]) => AuthHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );

  /// Access the file api for the `avatar` field
  static SingleFileHelper<User> avatarApi(String id) => FileHelper<User>(
        collection: 'users',
        id: id,
        field: 'avatar',
        mapper: User.fromMap,
      );
}

/// Static class containing all the string literals for your pocketbase collections.
abstract final class Collection {
  /// The name of the `users` collection.
  static const String users = 'users';
}
