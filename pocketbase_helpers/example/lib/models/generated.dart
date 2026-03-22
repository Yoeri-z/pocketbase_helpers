// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains custom json serializable models.
// add a `serializables_spec.dart` file next to this file to add imports for the missing types

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

/// Model for the `posts` collection.
class Post implements PocketBaseRecord {
  Post({
    required this.id,
    required this.title,
    this.content,
    this.thumbnail,
    required this.attachments,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  @override
  final String id;

  final String title;

  final String? content;

  final String? thumbnail;

  final List<String> attachments;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: (map['id'] as String),
      title: (map['title'] as String),
      content: (map['content'] as String?),
      thumbnail: (map['thumbnail'] as String?),
      attachments: (map['attachments'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'thumbnail': thumbnail,
        'attachments': attachments,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? thumbnail,
    List<String>? attachments,
    String? creatorId,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnail: thumbnail ?? this.thumbnail,
      attachments: attachments ?? this.attachments,
      creatorId: creatorId ?? this.creatorId,
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
        'posts',
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
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          thumbnail == other.thumbnail &&
          _listEquals(
            attachments,
            other.attachments,
          ) &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        content,
        thumbnail,
        Object.hashAll(attachments),
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `posts` collection.
abstract final class Posts {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'posts';

  ///Gets the [CollectionHelper] for the `posts` collection
  static CollectionHelper<Post> api([PocketBase? pocketBaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'posts',
        mapper: Post.fromMap,
      );

  /// Gets the [RealtimeHelper] for the `posts` collection
  static RealtimeHelper realtime({
    PocketBase? pb,
    Duration? debounce,
  }) =>
      RealtimeHelper(
        pocketBaseInstance: pb,
        collection: 'posts',
        mapper: Post.fromMap,
        debounce: debounce,
      );

  /// Access the file api for the `thumbnail` field
  static SingleFileHelper<Post> thumbnailApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<Post>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'posts',
        id: id,
        field: 'thumbnail',
        mapper: Post.fromMap,
      );

  /// Access the file api for the `attachments` field
  static MultiFileHelper<Post> attachmentsApi(
    String id, [
    PocketBase? pocketBaseInstance,
  ]) =>
      FileHelper<Post>(
        pocketBaseInstance: pocketBaseInstance,
        collection: 'posts',
        id: id,
        field: 'attachments',
        mapper: Post.fromMap,
      );
}

/// Static class containing all the string literals for your pocketbase collections.
abstract final class Collection {
  /// The name of the `users` collection.
  static const String users = 'users';

  /// The name of the `posts` collection.
  static const String posts = 'posts';
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
