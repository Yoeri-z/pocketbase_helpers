// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

/// Model for the _superusers collection.
class Superuser implements PocketBaseRecord {
  @override
  final String id;
  final String password;
  final String tokenKey;
  final String email;
  final bool emailVisibility;
  final bool verified;
  final DateTime created;
  final DateTime updated;

  Superuser({
    required this.id,
    required this.password,
    required this.tokenKey,
    required this.email,
    required this.emailVisibility,
    required this.verified,
    required this.created,
    required this.updated,
  });

  static Superuser fromMap(Map<String, dynamic> map) {
    return Superuser(
      id: map['id'] as String,
      password: map['password'] as String,
      tokenKey: map['tokenKey'] as String,
      email: map['email'] as String,
      emailVisibility: map['emailVisibility'] as bool,
      verified: map['verified'] as bool,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
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
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };

  Superuser copyWith({
    Object? id = _undefined,
    Object? password = _undefined,
    Object? tokenKey = _undefined,
    Object? email = _undefined,
    Object? emailVisibility = _undefined,
    Object? verified = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return Superuser(
      id: id == _undefined ? this.id : id as String,
      password: password == _undefined ? this.password : password as String,
      tokenKey: tokenKey == _undefined ? this.tokenKey : tokenKey as String,
      email: email == _undefined ? this.email : email as String,
      emailVisibility: emailVisibility == _undefined ? this.emailVisibility : emailVisibility as bool,
      verified: verified == _undefined ? this.verified : verified as bool,
      created: created == _undefined ? this.created : created as DateTime,
      updated: updated == _undefined ? this.updated : updated as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Superuser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          password == other.password &&
          tokenKey == other.tokenKey &&
          email == other.email &&
          emailVisibility == other.emailVisibility &&
          verified == other.verified &&
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
        created,
        updated,
      ]);

}

/// Helper for the _superusers collection.
abstract final class Superusers {
  static CollectionHelper<Superuser> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: '_superusers', mapper: Superuser.fromMap);
}

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
    Object? id = _undefined,
    Object? password = _undefined,
    Object? tokenKey = _undefined,
    Object? email = _undefined,
    Object? emailVisibility = _undefined,
    Object? verified = _undefined,
    Object? name = _undefined,
    Object? avatar = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return User(
      id: id == _undefined ? this.id : id as String,
      password: password == _undefined ? this.password : password as String,
      tokenKey: tokenKey == _undefined ? this.tokenKey : tokenKey as String,
      email: email == _undefined ? this.email : email as String,
      emailVisibility: emailVisibility == _undefined ? this.emailVisibility : emailVisibility as bool,
      verified: verified == _undefined ? this.verified : verified as bool,
      name: name == _undefined ? this.name : name as String?,
      avatar: avatar == _undefined ? this.avatar : avatar as String?,
      created: created == _undefined ? this.created : created as DateTime?,
      updated: updated == _undefined ? this.updated : updated as DateTime?,
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
  static CollectionHelper<User> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: 'users', mapper: User.fromMap);
}

/// Model for the _authOrigins collection.
class AuthOrigin implements PocketBaseRecord {
  @override
  final String id;
  final String collectionRef;
  final String recordRef;
  final String fingerprint;
  final DateTime created;
  final DateTime updated;

  AuthOrigin({
    required this.id,
    required this.collectionRef,
    required this.recordRef,
    required this.fingerprint,
    required this.created,
    required this.updated,
  });

  static AuthOrigin fromMap(Map<String, dynamic> map) {
    return AuthOrigin(
      id: map['id'] as String,
      collectionRef: map['collectionRef'] as String,
      recordRef: map['recordRef'] as String,
      fingerprint: map['fingerprint'] as String,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionRef': collectionRef,
    'recordRef': recordRef,
    'fingerprint': fingerprint,
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };

  AuthOrigin copyWith({
    Object? id = _undefined,
    Object? collectionRef = _undefined,
    Object? recordRef = _undefined,
    Object? fingerprint = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return AuthOrigin(
      id: id == _undefined ? this.id : id as String,
      collectionRef: collectionRef == _undefined ? this.collectionRef : collectionRef as String,
      recordRef: recordRef == _undefined ? this.recordRef : recordRef as String,
      fingerprint: fingerprint == _undefined ? this.fingerprint : fingerprint as String,
      created: created == _undefined ? this.created : created as DateTime,
      updated: updated == _undefined ? this.updated : updated as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthOrigin &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          collectionRef == other.collectionRef &&
          recordRef == other.recordRef &&
          fingerprint == other.fingerprint &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        collectionRef,
        recordRef,
        fingerprint,
        created,
        updated,
      ]);

}

/// Helper for the _authOrigins collection.
abstract final class AuthOrigins {
  static CollectionHelper<AuthOrigin> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: '_authOrigins', mapper: AuthOrigin.fromMap);
}

/// Model for the _externalAuths collection.
class ExternalAuth implements PocketBaseRecord {
  @override
  final String id;
  final String collectionRef;
  final String recordRef;
  final String provider;
  final String providerId;
  final DateTime created;
  final DateTime updated;

  ExternalAuth({
    required this.id,
    required this.collectionRef,
    required this.recordRef,
    required this.provider,
    required this.providerId,
    required this.created,
    required this.updated,
  });

  static ExternalAuth fromMap(Map<String, dynamic> map) {
    return ExternalAuth(
      id: map['id'] as String,
      collectionRef: map['collectionRef'] as String,
      recordRef: map['recordRef'] as String,
      provider: map['provider'] as String,
      providerId: map['providerId'] as String,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionRef': collectionRef,
    'recordRef': recordRef,
    'provider': provider,
    'providerId': providerId,
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };

  ExternalAuth copyWith({
    Object? id = _undefined,
    Object? collectionRef = _undefined,
    Object? recordRef = _undefined,
    Object? provider = _undefined,
    Object? providerId = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return ExternalAuth(
      id: id == _undefined ? this.id : id as String,
      collectionRef: collectionRef == _undefined ? this.collectionRef : collectionRef as String,
      recordRef: recordRef == _undefined ? this.recordRef : recordRef as String,
      provider: provider == _undefined ? this.provider : provider as String,
      providerId: providerId == _undefined ? this.providerId : providerId as String,
      created: created == _undefined ? this.created : created as DateTime,
      updated: updated == _undefined ? this.updated : updated as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExternalAuth &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          collectionRef == other.collectionRef &&
          recordRef == other.recordRef &&
          provider == other.provider &&
          providerId == other.providerId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        collectionRef,
        recordRef,
        provider,
        providerId,
        created,
        updated,
      ]);

}

/// Helper for the _externalAuths collection.
abstract final class ExternalAuths {
  static CollectionHelper<ExternalAuth> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: '_externalAuths', mapper: ExternalAuth.fromMap);
}

/// Model for the _mfas collection.
class Mfa implements PocketBaseRecord {
  @override
  final String id;
  final String collectionRef;
  final String recordRef;
  final String method;
  final DateTime created;
  final DateTime updated;

  Mfa({
    required this.id,
    required this.collectionRef,
    required this.recordRef,
    required this.method,
    required this.created,
    required this.updated,
  });

  static Mfa fromMap(Map<String, dynamic> map) {
    return Mfa(
      id: map['id'] as String,
      collectionRef: map['collectionRef'] as String,
      recordRef: map['recordRef'] as String,
      method: map['method'] as String,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionRef': collectionRef,
    'recordRef': recordRef,
    'method': method,
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };

  Mfa copyWith({
    Object? id = _undefined,
    Object? collectionRef = _undefined,
    Object? recordRef = _undefined,
    Object? method = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return Mfa(
      id: id == _undefined ? this.id : id as String,
      collectionRef: collectionRef == _undefined ? this.collectionRef : collectionRef as String,
      recordRef: recordRef == _undefined ? this.recordRef : recordRef as String,
      method: method == _undefined ? this.method : method as String,
      created: created == _undefined ? this.created : created as DateTime,
      updated: updated == _undefined ? this.updated : updated as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mfa &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          collectionRef == other.collectionRef &&
          recordRef == other.recordRef &&
          method == other.method &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        collectionRef,
        recordRef,
        method,
        created,
        updated,
      ]);

}

/// Helper for the _mfas collection.
abstract final class Mfas {
  static CollectionHelper<Mfa> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: '_mfas', mapper: Mfa.fromMap);
}

/// Model for the _otps collection.
class Otp implements PocketBaseRecord {
  @override
  final String id;
  final String collectionRef;
  final String recordRef;
  final String password;
  final String sentTo;
  final DateTime created;
  final DateTime updated;

  Otp({
    required this.id,
    required this.collectionRef,
    required this.recordRef,
    required this.password,
    required this.sentTo,
    required this.created,
    required this.updated,
  });

  static Otp fromMap(Map<String, dynamic> map) {
    return Otp(
      id: map['id'] as String,
      collectionRef: map['collectionRef'] as String,
      recordRef: map['recordRef'] as String,
      password: map['password'] as String,
      sentTo: map['sentTo'] as String,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionRef': collectionRef,
    'recordRef': recordRef,
    'password': password,
    'sentTo': sentTo,
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };

  Otp copyWith({
    Object? id = _undefined,
    Object? collectionRef = _undefined,
    Object? recordRef = _undefined,
    Object? password = _undefined,
    Object? sentTo = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return Otp(
      id: id == _undefined ? this.id : id as String,
      collectionRef: collectionRef == _undefined ? this.collectionRef : collectionRef as String,
      recordRef: recordRef == _undefined ? this.recordRef : recordRef as String,
      password: password == _undefined ? this.password : password as String,
      sentTo: sentTo == _undefined ? this.sentTo : sentTo as String,
      created: created == _undefined ? this.created : created as DateTime,
      updated: updated == _undefined ? this.updated : updated as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Otp &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          collectionRef == other.collectionRef &&
          recordRef == other.recordRef &&
          password == other.password &&
          sentTo == other.sentTo &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        collectionRef,
        recordRef,
        password,
        sentTo,
        created,
        updated,
      ]);

}

/// Helper for the _otps collection.
abstract final class Otps {
  static CollectionHelper<Otp> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: '_otps', mapper: Otp.fromMap);
}

/// Model for the base_collection collection.
class BaseCollection implements PocketBaseRecord {
  @override
  final String id;
  final String? textfield;
  final double? numberfield;
  final String? relationfield;
  final String? selectfield;
  final DateTime? created;
  final DateTime? updated;

  BaseCollection({
    required this.id,
    this.textfield,
    this.numberfield,
    this.relationfield,
    this.selectfield,
    this.created,
    this.updated,
  });

  static BaseCollection fromMap(Map<String, dynamic> map) {
    return BaseCollection(
      id: map['id'] as String,
      textfield: map['textfield'] as String?,
      numberfield: map['numberfield'] != null ? (map['numberfield'] as num).toDouble() : null,
      relationfield: map['relationfield'] as String?,
      selectfield: map['selectfield'] as String?,
      created: map['created'] != null ? DateTime.parse(map['created'] as String) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'textfield': textfield,
    'numberfield': numberfield,
    'relationfield': relationfield,
    'selectfield': selectfield,
    'created': created?.toIso8601String(),
    'updated': updated?.toIso8601String(),
  };

  BaseCollection copyWith({
    Object? id = _undefined,
    Object? textfield = _undefined,
    Object? numberfield = _undefined,
    Object? relationfield = _undefined,
    Object? selectfield = _undefined,
    Object? created = _undefined,
    Object? updated = _undefined,
  }) {
    return BaseCollection(
      id: id == _undefined ? this.id : id as String,
      textfield: textfield == _undefined ? this.textfield : textfield as String?,
      numberfield: numberfield == _undefined ? this.numberfield : numberfield as double?,
      relationfield: relationfield == _undefined ? this.relationfield : relationfield as String?,
      selectfield: selectfield == _undefined ? this.selectfield : selectfield as String?,
      created: created == _undefined ? this.created : created as DateTime?,
      updated: updated == _undefined ? this.updated : updated as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseCollection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          textfield == other.textfield &&
          numberfield == other.numberfield &&
          relationfield == other.relationfield &&
          selectfield == other.selectfield &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        textfield,
        numberfield,
        relationfield,
        selectfield,
        created,
        updated,
      ]);

}

/// Helper for the base_collection collection.
abstract final class BaseCollections {
  static CollectionHelper<BaseCollection> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: 'base_collection', mapper: BaseCollection.fromMap);
}

/// Model for the view_collection collection.
class ViewCollection implements PocketBaseRecord {
  @override
  final String id;
  final String? textfield;

  ViewCollection({
    required this.id,
    this.textfield,
  });

  static ViewCollection fromMap(Map<String, dynamic> map) {
    return ViewCollection(
      id: map['id'] as String,
      textfield: map['textfield'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'textfield': textfield,
  };

  ViewCollection copyWith({
    Object? id = _undefined,
    Object? textfield = _undefined,
  }) {
    return ViewCollection(
      id: id == _undefined ? this.id : id as String,
      textfield: textfield == _undefined ? this.textfield : textfield as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewCollection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          textfield == other.textfield;

  @override
  int get hashCode => Object.hashAll([
        id,
        textfield,
      ]);

}

/// Helper for the view_collection collection.
abstract final class ViewCollections {
  static CollectionHelper<ViewCollection> helper(PocketBase pb) =>
      CollectionHelper(pb, collection: 'view_collection', mapper: ViewCollection.fromMap);
}

const _undefined = Object();

