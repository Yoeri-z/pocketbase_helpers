// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

/// Model for the users collection.
class User implements PocketBaseRecord {
  @override
  final String id;
  final String password;
  final String tokenKey;
  final String email;
  final bool emailVisibility;
  final bool verified;
  final String? name;
  final String? avatar;
  final DateTime? created;
  final DateTime? updated;

  User({
    required this.id,
    required this.password,
    required this.tokenKey,
    required this.email,
    required this.emailVisibility,
    required this.verified,
    this.name,
    this.avatar,
    this.created,
    this.updated,
  });

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      password: map['password'] as String,
      tokenKey: map['tokenKey'] as String,
      email: map['email'] as String,
      emailVisibility: map['emailVisibility'] as bool,
      verified: map['verified'] as bool,
      name: map['name'] as String?,
      avatar: map['avatar'] as String?,
      created: map['created'] != null ? DateTime.parse(map['created'] as String) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated'] as String) : null,
    );
  }
  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'password': password,
    'tokenKey': tokenKey,
    'email': email,
    'emailVisibility': emailVisibility,
    'verified': verified,
    'name': name,
    'avatar': avatar,
    'created': created?.toIso8601String(),
    'updated': updated?.toIso8601String(),
  };

  User copyWith({
    String? id,
    String? password,
    String? tokenKey,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      password: password ?? this.password,
      tokenKey: tokenKey ?? this.tokenKey,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          password == other.password &&
          tokenKey == other.tokenKey &&
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
        password,
        tokenKey,
        email,
        emailVisibility,
        verified,
        name,
        avatar,
        created,
        updated,
      ]);

}

/// Helper for the users collection.
abstract final class Users {
  ///Get the [CollectionHelper] for the users collection
  static CollectionHelper<User> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: 'users', mapper: User.fromMap);
}


