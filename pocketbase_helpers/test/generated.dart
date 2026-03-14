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
    required this.scope,
    this.groupId,
    required this.created,
    required this.updated,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: (map['id'] as String),
      email: (map['email'] as String),
      emailVisibility: (map['emailVisibility'] as bool),
      verified: (map['verified'] as bool),
      name: (map['name'] as String?),
      avatar: (map['avatar'] as String?),
      scope: (map['scope'] as String),
      groupId: (map['group_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String email;

  final bool emailVisibility;

  final bool verified;

  final String? name;

  final String? avatar;

  final String scope;

  final String? groupId;

  final DateTime created;

  final DateTime updated;

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
  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'emailVisibility': emailVisibility,
        'verified': verified,
        'name': name,
        'avatar': avatar,
        'scope': scope,
        'group_id': groupId,
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
    String? scope,
    String? groupId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      scope: scope ?? this.scope,
      groupId: groupId ?? this.groupId,
      created: created,
      updated: updated,
    );
  }

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
          scope == other.scope &&
          groupId == other.groupId &&
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
        scope,
        groupId,
        created,
        updated,
      ]);
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

  ///Gets the [AuthHelper] for the `users` collection
  static AuthHelper<User> auth([PocketBase? pocketbaseInstance]) => AuthHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );

  /// Access the file api for the `avatar` field
  SingleFileHelper<User> avatarApi(String id) => FileHelper<User>(
        collection: 'users',
        id: id,
        field: 'avatar',
        mapper: User.fromMap,
      );
}

/// Model for the `address_book` collection.
class AddressBook implements PocketBaseRecord {
  AddressBook({
    required this.id,
    required this.address,
    this.usageCount,
    required this.created,
    required this.updated,
  });

  factory AddressBook.fromMap(Map<String, dynamic> map) {
    return AddressBook(
      id: (map['id'] as String),
      address: map['address'],
      usageCount: map['usage_count'] != null
          ? (map['usage_count'] as num).toDouble()
          : null,
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final dynamic address;

  final double? usageCount;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'address_book',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'address': address,
        'usage_count': usageCount,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  AddressBook copyWith({
    String? id,
    dynamic address,
    double? usageCount,
  }) {
    return AddressBook(
      id: id ?? this.id,
      address: address ?? this.address,
      usageCount: usageCount ?? this.usageCount,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is AddressBook &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          address == other.address &&
          usageCount == other.usageCount &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        address,
        usageCount,
        created,
        updated,
      ]);
}

/// Helper for the `address_book` collection.
abstract final class AddressBooks {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'address_book';

  ///Gets the [CollectionHelper] for the `address_book` collection
  static CollectionHelper<AddressBook> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'address_book',
        mapper: AddressBook.fromMap,
      );
}

/// Model for the `archetype_nodes` collection.
class ArchetypeNode implements PocketBaseRecord {
  ArchetypeNode({
    required this.id,
    required this.archetypeId,
    required this.childIds,
    required this.created,
    required this.updated,
  });

  factory ArchetypeNode.fromMap(Map<String, dynamic> map) {
    return ArchetypeNode(
      id: (map['id'] as String),
      archetypeId: (map['archetype_id'] as String),
      childIds: (map['child_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String archetypeId;

  final List<String> childIds;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'archetype_nodes',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'archetype_id': archetypeId,
        'child_ids': childIds,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  ArchetypeNode copyWith({
    String? id,
    String? archetypeId,
    List<String>? childIds,
  }) {
    return ArchetypeNode(
      id: id ?? this.id,
      archetypeId: archetypeId ?? this.archetypeId,
      childIds: childIds ?? this.childIds,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is ArchetypeNode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          archetypeId == other.archetypeId &&
          _listEquals(
            childIds,
            other.childIds,
          ) &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        archetypeId,
        Object.hashAll(childIds),
        created,
        updated,
      ]);
}

/// Helper for the `archetype_nodes` collection.
abstract final class ArchetypeNodes {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'archetype_nodes';

  ///Gets the [CollectionHelper] for the `archetype_nodes` collection
  static CollectionHelper<ArchetypeNode> api(
          [PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'archetype_nodes',
        mapper: ArchetypeNode.fromMap,
      );
}

/// Model for the `archetypes` collection.
class Archetype implements PocketBaseRecord {
  Archetype({
    required this.id,
    required this.name,
    required this.categoryIds,
    this.manufacturer,
    this.sku,
    this.customFields,
    required this.issueIds,
    required this.files,
    this.thumbnail,
    this.notes,
    this.creatorId,
    this.lowStockCutoff,
    this.stockCount,
    required this.created,
    required this.updated,
  });

  factory Archetype.fromMap(Map<String, dynamic> map) {
    return Archetype(
      id: (map['id'] as String),
      name: (map['name'] as String),
      categoryIds: (map['category_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      manufacturer: (map['manufacturer'] as String?),
      sku: (map['sku'] as String?),
      customFields: map['custom_fields'],
      issueIds: (map['issue_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      files: (map['files'] as List<dynamic>).map((e) => (e as String)).toList(),
      thumbnail: (map['thumbnail'] as String?),
      notes: (map['notes'] as String?),
      creatorId: (map['creator_id'] as String?),
      lowStockCutoff: map['low_stock_cutoff'] != null
          ? (map['low_stock_cutoff'] as num).toDouble()
          : null,
      stockCount: map['stock_count'] != null
          ? (map['stock_count'] as num).toDouble()
          : null,
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final List<String> categoryIds;

  final String? manufacturer;

  final String? sku;

  final dynamic customFields;

  final List<String> issueIds;

  final List<String> files;

  final String? thumbnail;

  final String? notes;

  final String? creatorId;

  final double? lowStockCutoff;

  final double? stockCount;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'archetypes',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category_ids': categoryIds,
        'manufacturer': manufacturer,
        'sku': sku,
        'custom_fields': customFields,
        'issue_ids': issueIds,
        'files': files,
        'thumbnail': thumbnail,
        'notes': notes,
        'creator_id': creatorId,
        'low_stock_cutoff': lowStockCutoff,
        'stock_count': stockCount,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Archetype copyWith({
    String? id,
    String? name,
    List<String>? categoryIds,
    String? manufacturer,
    String? sku,
    dynamic customFields,
    List<String>? issueIds,
    List<String>? files,
    String? thumbnail,
    String? notes,
    String? creatorId,
    double? lowStockCutoff,
    double? stockCount,
  }) {
    return Archetype(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryIds: categoryIds ?? this.categoryIds,
      manufacturer: manufacturer ?? this.manufacturer,
      sku: sku ?? this.sku,
      customFields: customFields ?? this.customFields,
      issueIds: issueIds ?? this.issueIds,
      files: files ?? this.files,
      thumbnail: thumbnail ?? this.thumbnail,
      notes: notes ?? this.notes,
      creatorId: creatorId ?? this.creatorId,
      lowStockCutoff: lowStockCutoff ?? this.lowStockCutoff,
      stockCount: stockCount ?? this.stockCount,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Archetype &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          _listEquals(
            categoryIds,
            other.categoryIds,
          ) &&
          manufacturer == other.manufacturer &&
          sku == other.sku &&
          customFields == other.customFields &&
          _listEquals(
            issueIds,
            other.issueIds,
          ) &&
          _listEquals(
            files,
            other.files,
          ) &&
          thumbnail == other.thumbnail &&
          notes == other.notes &&
          creatorId == other.creatorId &&
          lowStockCutoff == other.lowStockCutoff &&
          stockCount == other.stockCount &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        Object.hashAll(categoryIds),
        manufacturer,
        sku,
        customFields,
        Object.hashAll(issueIds),
        Object.hashAll(files),
        thumbnail,
        notes,
        creatorId,
        lowStockCutoff,
        stockCount,
        created,
        updated,
      ]);
}

/// Helper for the `archetypes` collection.
abstract final class Archetypes {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'archetypes';

  ///Gets the [CollectionHelper] for the `archetypes` collection
  static CollectionHelper<Archetype> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'archetypes',
        mapper: Archetype.fromMap,
      );

  /// Access the file api for the `files` field
  MultiFileHelper<Archetype> filesApi(String id) => FileHelper<Archetype>(
        collection: 'archetypes',
        id: id,
        field: 'files',
        mapper: Archetype.fromMap,
      );

  /// Access the file api for the `thumbnail` field
  SingleFileHelper<Archetype> thumbnailApi(String id) => FileHelper<Archetype>(
        collection: 'archetypes',
        id: id,
        field: 'thumbnail',
        mapper: Archetype.fromMap,
      );
}

/// Model for the `categories` collection.
class Category implements PocketBaseRecord {
  Category({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.created,
    required this.updated,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: (map['id'] as String),
      name: (map['name'] as String),
      description: (map['description'] as String?),
      color: map['color'] != null ? (map['color'] as num).toDouble() : null,
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final String? description;

  final double? color;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'categories',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'color': color,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Category copyWith({
    String? id,
    String? name,
    String? description,
    double? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        description,
        color,
        created,
        updated,
      ]);
}

/// Helper for the `categories` collection.
abstract final class Categories {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'categories';

  ///Gets the [CollectionHelper] for the `categories` collection
  static CollectionHelper<Category> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'categories',
        mapper: Category.fromMap,
      );
}

/// Model for the `checklists` collection.
class Checklist implements PocketBaseRecord {
  Checklist({
    required this.id,
    required this.name,
    this.description,
    this.items,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      id: (map['id'] as String),
      name: (map['name'] as String),
      description: (map['description'] as String?),
      items: map['items'],
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final String? description;

  final dynamic items;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'checklists',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'items': items,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Checklist copyWith({
    String? id,
    String? name,
    String? description,
    dynamic items,
    String? creatorId,
  }) {
    return Checklist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Checklist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          items == other.items &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        description,
        items,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `checklists` collection.
abstract final class Checklists {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'checklists';

  ///Gets the [CollectionHelper] for the `checklists` collection
  static CollectionHelper<Checklist> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'checklists',
        mapper: Checklist.fromMap,
      );
}

/// Model for the `configuration` collection.
class Configuration implements PocketBaseRecord {
  Configuration({
    required this.id,
    required this.applicationColor,
    required this.applicationSchemeVariant,
    required this.applicationName,
    required this.systemsHaveWarranty,
    this.defaultWarrantyTime,
    required this.customFields,
    required this.created,
    required this.updated,
  });

  factory Configuration.fromMap(Map<String, dynamic> map) {
    return Configuration(
      id: (map['id'] as String),
      applicationColor: (map['application_color'] as num).toDouble(),
      applicationSchemeVariant: (map['application_scheme_variant'] as String),
      applicationName: (map['application_name'] as String),
      systemsHaveWarranty: (map['systems_have_warranty'] as bool),
      defaultWarrantyTime: map['default_warranty_time'] != null
          ? (map['default_warranty_time'] as num).toDouble()
          : null,
      customFields: map['custom_fields'],
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final double applicationColor;

  final String applicationSchemeVariant;

  final String applicationName;

  final bool systemsHaveWarranty;

  final double? defaultWarrantyTime;

  final dynamic customFields;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'configuration',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'application_color': applicationColor,
        'application_scheme_variant': applicationSchemeVariant,
        'application_name': applicationName,
        'systems_have_warranty': systemsHaveWarranty,
        'default_warranty_time': defaultWarrantyTime,
        'custom_fields': customFields,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Configuration copyWith({
    String? id,
    double? applicationColor,
    String? applicationSchemeVariant,
    String? applicationName,
    bool? systemsHaveWarranty,
    double? defaultWarrantyTime,
    dynamic customFields,
  }) {
    return Configuration(
      id: id ?? this.id,
      applicationColor: applicationColor ?? this.applicationColor,
      applicationSchemeVariant:
          applicationSchemeVariant ?? this.applicationSchemeVariant,
      applicationName: applicationName ?? this.applicationName,
      systemsHaveWarranty: systemsHaveWarranty ?? this.systemsHaveWarranty,
      defaultWarrantyTime: defaultWarrantyTime ?? this.defaultWarrantyTime,
      customFields: customFields ?? this.customFields,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Configuration &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          applicationColor == other.applicationColor &&
          applicationSchemeVariant == other.applicationSchemeVariant &&
          applicationName == other.applicationName &&
          systemsHaveWarranty == other.systemsHaveWarranty &&
          defaultWarrantyTime == other.defaultWarrantyTime &&
          customFields == other.customFields &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        applicationColor,
        applicationSchemeVariant,
        applicationName,
        systemsHaveWarranty,
        defaultWarrantyTime,
        customFields,
        created,
        updated,
      ]);
}

/// Helper for the `configuration` collection.
abstract final class Configurations {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'configuration';

  ///Gets the [CollectionHelper] for the `configuration` collection
  static CollectionHelper<Configuration> api(
          [PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'configuration',
        mapper: Configuration.fromMap,
      );
}

/// Model for the `contacts` collection.
class Contact implements PocketBaseRecord {
  Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.customFields,
    this.notes,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: (map['id'] as String),
      name: (map['name'] as String),
      email: (map['email'] as String?),
      phone: (map['phone'] as String?),
      customFields: map['custom_fields'],
      notes: (map['notes'] as String?),
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final String? email;

  final String? phone;

  final dynamic customFields;

  final String? notes;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'contacts',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'custom_fields': customFields,
        'notes': notes,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Contact copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    dynamic customFields,
    String? notes,
    String? creatorId,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      customFields: customFields ?? this.customFields,
      notes: notes ?? this.notes,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          customFields == other.customFields &&
          notes == other.notes &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        email,
        phone,
        customFields,
        notes,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `contacts` collection.
abstract final class Contacts {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'contacts';

  ///Gets the [CollectionHelper] for the `contacts` collection
  static CollectionHelper<Contact> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'contacts',
        mapper: Contact.fromMap,
      );
}

/// Model for the `groups` collection.
class Group implements PocketBaseRecord {
  Group({
    required this.id,
    required this.name,
    required this.contactIds,
    required this.address,
    this.customFields,
    this.notes,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: (map['id'] as String),
      name: (map['name'] as String),
      contactIds: (map['contact_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      address: map['address'],
      customFields: map['custom_fields'],
      notes: (map['notes'] as String?),
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final List<String> contactIds;

  final dynamic address;

  final dynamic customFields;

  final String? notes;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'groups',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'contact_ids': contactIds,
        'address': address,
        'custom_fields': customFields,
        'notes': notes,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Group copyWith({
    String? id,
    String? name,
    List<String>? contactIds,
    dynamic address,
    dynamic customFields,
    String? notes,
    String? creatorId,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      contactIds: contactIds ?? this.contactIds,
      address: address ?? this.address,
      customFields: customFields ?? this.customFields,
      notes: notes ?? this.notes,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          _listEquals(
            contactIds,
            other.contactIds,
          ) &&
          address == other.address &&
          customFields == other.customFields &&
          notes == other.notes &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        Object.hashAll(contactIds),
        address,
        customFields,
        notes,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `groups` collection.
abstract final class Groups {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'groups';

  ///Gets the [CollectionHelper] for the `groups` collection
  static CollectionHelper<Group> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'groups',
        mapper: Group.fromMap,
      );
}

/// Model for the `issues` collection.
class Issue implements PocketBaseRecord {
  Issue({
    required this.id,
    required this.title,
    this.description,
    this.priority,
    this.statusId,
    required this.labelIds,
    required this.systemIds,
    required this.systemArchetypeIds,
    required this.partIds,
    required this.archetypeIds,
    required this.files,
    this.history,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: (map['id'] as String),
      title: (map['title'] as String),
      description: (map['description'] as String?),
      priority:
          map['priority'] != null ? (map['priority'] as num).toDouble() : null,
      statusId: (map['status_id'] as String?),
      labelIds: (map['label_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      systemIds: (map['system_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      systemArchetypeIds: (map['system_archetype_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      partIds:
          (map['part_ids'] as List<dynamic>).map((e) => (e as String)).toList(),
      archetypeIds: (map['archetype_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      files: (map['files'] as List<dynamic>).map((e) => (e as String)).toList(),
      history: map['history'],
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String title;

  final String? description;

  final double? priority;

  final String? statusId;

  final List<String> labelIds;

  final List<String> systemIds;

  final List<String> systemArchetypeIds;

  final List<String> partIds;

  final List<String> archetypeIds;

  final List<String> files;

  final dynamic history;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'issues',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'status_id': statusId,
        'label_ids': labelIds,
        'system_ids': systemIds,
        'system_archetype_ids': systemArchetypeIds,
        'part_ids': partIds,
        'archetype_ids': archetypeIds,
        'files': files,
        'history': history,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Issue copyWith({
    String? id,
    String? title,
    String? description,
    double? priority,
    String? statusId,
    List<String>? labelIds,
    List<String>? systemIds,
    List<String>? systemArchetypeIds,
    List<String>? partIds,
    List<String>? archetypeIds,
    List<String>? files,
    dynamic history,
    String? creatorId,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      statusId: statusId ?? this.statusId,
      labelIds: labelIds ?? this.labelIds,
      systemIds: systemIds ?? this.systemIds,
      systemArchetypeIds: systemArchetypeIds ?? this.systemArchetypeIds,
      partIds: partIds ?? this.partIds,
      archetypeIds: archetypeIds ?? this.archetypeIds,
      files: files ?? this.files,
      history: history ?? this.history,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Issue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          priority == other.priority &&
          statusId == other.statusId &&
          _listEquals(
            labelIds,
            other.labelIds,
          ) &&
          _listEquals(
            systemIds,
            other.systemIds,
          ) &&
          _listEquals(
            systemArchetypeIds,
            other.systemArchetypeIds,
          ) &&
          _listEquals(
            partIds,
            other.partIds,
          ) &&
          _listEquals(
            archetypeIds,
            other.archetypeIds,
          ) &&
          _listEquals(
            files,
            other.files,
          ) &&
          history == other.history &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        priority,
        statusId,
        Object.hashAll(labelIds),
        Object.hashAll(systemIds),
        Object.hashAll(systemArchetypeIds),
        Object.hashAll(partIds),
        Object.hashAll(archetypeIds),
        Object.hashAll(files),
        history,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `issues` collection.
abstract final class Issues {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'issues';

  ///Gets the [CollectionHelper] for the `issues` collection
  static CollectionHelper<Issue> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'issues',
        mapper: Issue.fromMap,
      );

  /// Access the file api for the `files` field
  MultiFileHelper<Issue> filesApi(String id) => FileHelper<Issue>(
        collection: 'issues',
        id: id,
        field: 'files',
        mapper: Issue.fromMap,
      );
}

/// Model for the `part_nodes` collection.
class PartNode implements PocketBaseRecord {
  PartNode({
    required this.id,
    required this.archetypeId,
    this.partId,
    required this.childIds,
    required this.created,
    required this.updated,
  });

  factory PartNode.fromMap(Map<String, dynamic> map) {
    return PartNode(
      id: (map['id'] as String),
      archetypeId: (map['archetype_id'] as String),
      partId: (map['part_id'] as String?),
      childIds: (map['child_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String archetypeId;

  final String? partId;

  final List<String> childIds;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'part_nodes',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'archetype_id': archetypeId,
        'part_id': partId,
        'child_ids': childIds,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  PartNode copyWith({
    String? id,
    String? archetypeId,
    String? partId,
    List<String>? childIds,
  }) {
    return PartNode(
      id: id ?? this.id,
      archetypeId: archetypeId ?? this.archetypeId,
      partId: partId ?? this.partId,
      childIds: childIds ?? this.childIds,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is PartNode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          archetypeId == other.archetypeId &&
          partId == other.partId &&
          _listEquals(
            childIds,
            other.childIds,
          ) &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        archetypeId,
        partId,
        Object.hashAll(childIds),
        created,
        updated,
      ]);
}

/// Helper for the `part_nodes` collection.
abstract final class PartNodes {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'part_nodes';

  ///Gets the [CollectionHelper] for the `part_nodes` collection
  static CollectionHelper<PartNode> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'part_nodes',
        mapper: PartNode.fromMap,
      );
}

/// Model for the `parts` collection.
class Part implements PocketBaseRecord {
  Part({
    required this.id,
    this.serialNumber,
    required this.archetypeId,
    this.systemId,
    this.shipmentId,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: (map['id'] as String),
      serialNumber: (map['serial_number'] as String?),
      archetypeId: (map['archetype_id'] as String),
      systemId: (map['system_id'] as String?),
      shipmentId: (map['shipment_id'] as String?),
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String? serialNumber;

  final String archetypeId;

  final String? systemId;

  final String? shipmentId;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'parts',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'serial_number': serialNumber,
        'archetype_id': archetypeId,
        'system_id': systemId,
        'shipment_id': shipmentId,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Part copyWith({
    String? id,
    String? serialNumber,
    String? archetypeId,
    String? systemId,
    String? shipmentId,
    String? creatorId,
  }) {
    return Part(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      archetypeId: archetypeId ?? this.archetypeId,
      systemId: systemId ?? this.systemId,
      shipmentId: shipmentId ?? this.shipmentId,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Part &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serialNumber == other.serialNumber &&
          archetypeId == other.archetypeId &&
          systemId == other.systemId &&
          shipmentId == other.shipmentId &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        serialNumber,
        archetypeId,
        systemId,
        shipmentId,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `parts` collection.
abstract final class Parts {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'parts';

  ///Gets the [CollectionHelper] for the `parts` collection
  static CollectionHelper<Part> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'parts',
        mapper: Part.fromMap,
      );
}

/// Model for the `shipments` collection.
class Shipment implements PocketBaseRecord {
  Shipment({
    required this.id,
    required this.title,
    this.trackingLink,
    required this.statusId,
    this.senderAddress,
    this.receiverAddress,
    this.expectedDeliveryDate,
    this.systemId,
    required this.partIds,
    required this.isReturning,
    this.notes,
    this.creatorId,
    this.shippedDate,
    this.deliveredDate,
    required this.created,
    required this.updated,
  });

  factory Shipment.fromMap(Map<String, dynamic> map) {
    return Shipment(
      id: (map['id'] as String),
      title: (map['title'] as String),
      trackingLink: (map['tracking_link'] as String?),
      statusId: (map['status_id'] as String),
      senderAddress: map['sender_address'],
      receiverAddress: map['receiver_address'],
      expectedDeliveryDate: map['expected_delivery_date'] != null
          ? DateTime.parse((map['expected_delivery_date'] as String))
          : null,
      systemId: (map['system_id'] as String?),
      partIds:
          (map['part_ids'] as List<dynamic>).map((e) => (e as String)).toList(),
      isReturning: (map['is_returning'] as bool),
      notes: (map['notes'] as String?),
      creatorId: (map['creator_id'] as String?),
      shippedDate: map['shipped_date'] != null
          ? DateTime.parse((map['shipped_date'] as String))
          : null,
      deliveredDate: map['delivered_date'] != null
          ? DateTime.parse((map['delivered_date'] as String))
          : null,
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String title;

  final String? trackingLink;

  final String statusId;

  final dynamic senderAddress;

  final dynamic receiverAddress;

  final DateTime? expectedDeliveryDate;

  final String? systemId;

  final List<String> partIds;

  final bool isReturning;

  final String? notes;

  final String? creatorId;

  final DateTime? shippedDate;

  final DateTime? deliveredDate;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'shipments',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'tracking_link': trackingLink,
        'status_id': statusId,
        'sender_address': senderAddress,
        'receiver_address': receiverAddress,
        'expected_delivery_date': expectedDeliveryDate?.toIso8601String(),
        'system_id': systemId,
        'part_ids': partIds,
        'is_returning': isReturning,
        'notes': notes,
        'creator_id': creatorId,
        'shipped_date': shippedDate?.toIso8601String(),
        'delivered_date': deliveredDate?.toIso8601String(),
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Shipment copyWith({
    String? id,
    String? title,
    String? trackingLink,
    String? statusId,
    dynamic senderAddress,
    dynamic receiverAddress,
    DateTime? expectedDeliveryDate,
    String? systemId,
    List<String>? partIds,
    bool? isReturning,
    String? notes,
    String? creatorId,
    DateTime? shippedDate,
    DateTime? deliveredDate,
  }) {
    return Shipment(
      id: id ?? this.id,
      title: title ?? this.title,
      trackingLink: trackingLink ?? this.trackingLink,
      statusId: statusId ?? this.statusId,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      systemId: systemId ?? this.systemId,
      partIds: partIds ?? this.partIds,
      isReturning: isReturning ?? this.isReturning,
      notes: notes ?? this.notes,
      creatorId: creatorId ?? this.creatorId,
      shippedDate: shippedDate ?? this.shippedDate,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Shipment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          trackingLink == other.trackingLink &&
          statusId == other.statusId &&
          senderAddress == other.senderAddress &&
          receiverAddress == other.receiverAddress &&
          expectedDeliveryDate == other.expectedDeliveryDate &&
          systemId == other.systemId &&
          _listEquals(
            partIds,
            other.partIds,
          ) &&
          isReturning == other.isReturning &&
          notes == other.notes &&
          creatorId == other.creatorId &&
          shippedDate == other.shippedDate &&
          deliveredDate == other.deliveredDate &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        trackingLink,
        statusId,
        senderAddress,
        receiverAddress,
        expectedDeliveryDate,
        systemId,
        Object.hashAll(partIds),
        isReturning,
        notes,
        creatorId,
        shippedDate,
        deliveredDate,
        created,
        updated,
      ]);
}

/// Helper for the `shipments` collection.
abstract final class Shipments {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'shipments';

  ///Gets the [CollectionHelper] for the `shipments` collection
  static CollectionHelper<Shipment> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'shipments',
        mapper: Shipment.fromMap,
      );
}

/// Model for the `system_archetypes` collection.
class SystemArchetype implements PocketBaseRecord {
  SystemArchetype({
    required this.id,
    this.thumbnail,
    this.title,
    this.description,
    required this.checklistIds,
    required this.rootNodeIds,
    required this.files,
    this.sku,
    required this.created,
    required this.updated,
  });

  factory SystemArchetype.fromMap(Map<String, dynamic> map) {
    return SystemArchetype(
      id: (map['id'] as String),
      thumbnail: (map['thumbnail'] as String?),
      title: (map['title'] as String?),
      description: (map['description'] as String?),
      checklistIds: (map['checklist_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      rootNodeIds: (map['root_node_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      files: (map['files'] as List<dynamic>).map((e) => (e as String)).toList(),
      sku: (map['sku'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String? thumbnail;

  final String? title;

  final String? description;

  final List<String> checklistIds;

  final List<String> rootNodeIds;

  final List<String> files;

  final String? sku;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'system_archetypes',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'thumbnail': thumbnail,
        'title': title,
        'description': description,
        'checklist_ids': checklistIds,
        'root_node_ids': rootNodeIds,
        'files': files,
        'sku': sku,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  SystemArchetype copyWith({
    String? id,
    String? thumbnail,
    String? title,
    String? description,
    List<String>? checklistIds,
    List<String>? rootNodeIds,
    List<String>? files,
    String? sku,
  }) {
    return SystemArchetype(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      description: description ?? this.description,
      checklistIds: checklistIds ?? this.checklistIds,
      rootNodeIds: rootNodeIds ?? this.rootNodeIds,
      files: files ?? this.files,
      sku: sku ?? this.sku,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is SystemArchetype &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          thumbnail == other.thumbnail &&
          title == other.title &&
          description == other.description &&
          _listEquals(
            checklistIds,
            other.checklistIds,
          ) &&
          _listEquals(
            rootNodeIds,
            other.rootNodeIds,
          ) &&
          _listEquals(
            files,
            other.files,
          ) &&
          sku == other.sku &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        thumbnail,
        title,
        description,
        Object.hashAll(checklistIds),
        Object.hashAll(rootNodeIds),
        Object.hashAll(files),
        sku,
        created,
        updated,
      ]);
}

/// Helper for the `system_archetypes` collection.
abstract final class SystemArchetypes {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'system_archetypes';

  ///Gets the [CollectionHelper] for the `system_archetypes` collection
  static CollectionHelper<SystemArchetype> api(
          [PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'system_archetypes',
        mapper: SystemArchetype.fromMap,
      );

  /// Access the file api for the `thumbnail` field
  SingleFileHelper<SystemArchetype> thumbnailApi(String id) =>
      FileHelper<SystemArchetype>(
        collection: 'system_archetypes',
        id: id,
        field: 'thumbnail',
        mapper: SystemArchetype.fromMap,
      );

  /// Access the file api for the `files` field
  MultiFileHelper<SystemArchetype> filesApi(String id) =>
      FileHelper<SystemArchetype>(
        collection: 'system_archetypes',
        id: id,
        field: 'files',
        mapper: SystemArchetype.fromMap,
      );
}

/// Model for the `systems` collection.
class System implements PocketBaseRecord {
  System({
    required this.id,
    required this.name,
    required this.contactIds,
    required this.groupIds,
    this.archetypeId,
    this.checklist,
    required this.rootNodeIds,
    this.latestSoftwareUpdate,
    this.warranty,
    required this.files,
    this.customFields,
    this.notes,
    this.creatorId,
    required this.created,
    required this.updated,
  });

  factory System.fromMap(Map<String, dynamic> map) {
    return System(
      id: (map['id'] as String),
      name: (map['name'] as String),
      contactIds: (map['contact_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      groupIds: (map['group_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      archetypeId: (map['archetype_id'] as String?),
      checklist: map['checklist'],
      rootNodeIds: (map['root_node_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      latestSoftwareUpdate: map['latest_software_update'] != null
          ? DateTime.parse((map['latest_software_update'] as String))
          : null,
      warranty: map['warranty'] != null
          ? DateTime.parse((map['warranty'] as String))
          : null,
      files: (map['files'] as List<dynamic>).map((e) => (e as String)).toList(),
      customFields: map['custom_fields'],
      notes: (map['notes'] as String?),
      creatorId: (map['creator_id'] as String?),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final List<String> contactIds;

  final List<String> groupIds;

  final String? archetypeId;

  final dynamic checklist;

  final List<String> rootNodeIds;

  final DateTime? latestSoftwareUpdate;

  final DateTime? warranty;

  final List<String> files;

  final dynamic customFields;

  final String? notes;

  final String? creatorId;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'systems',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'contact_ids': contactIds,
        'group_ids': groupIds,
        'archetype_id': archetypeId,
        'checklist': checklist,
        'root_node_ids': rootNodeIds,
        'latest_software_update': latestSoftwareUpdate?.toIso8601String(),
        'warranty': warranty?.toIso8601String(),
        'files': files,
        'custom_fields': customFields,
        'notes': notes,
        'creator_id': creatorId,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  System copyWith({
    String? id,
    String? name,
    List<String>? contactIds,
    List<String>? groupIds,
    String? archetypeId,
    dynamic checklist,
    List<String>? rootNodeIds,
    DateTime? latestSoftwareUpdate,
    DateTime? warranty,
    List<String>? files,
    dynamic customFields,
    String? notes,
    String? creatorId,
  }) {
    return System(
      id: id ?? this.id,
      name: name ?? this.name,
      contactIds: contactIds ?? this.contactIds,
      groupIds: groupIds ?? this.groupIds,
      archetypeId: archetypeId ?? this.archetypeId,
      checklist: checklist ?? this.checklist,
      rootNodeIds: rootNodeIds ?? this.rootNodeIds,
      latestSoftwareUpdate: latestSoftwareUpdate ?? this.latestSoftwareUpdate,
      warranty: warranty ?? this.warranty,
      files: files ?? this.files,
      customFields: customFields ?? this.customFields,
      notes: notes ?? this.notes,
      creatorId: creatorId ?? this.creatorId,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is System &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          _listEquals(
            contactIds,
            other.contactIds,
          ) &&
          _listEquals(
            groupIds,
            other.groupIds,
          ) &&
          archetypeId == other.archetypeId &&
          checklist == other.checklist &&
          _listEquals(
            rootNodeIds,
            other.rootNodeIds,
          ) &&
          latestSoftwareUpdate == other.latestSoftwareUpdate &&
          warranty == other.warranty &&
          _listEquals(
            files,
            other.files,
          ) &&
          customFields == other.customFields &&
          notes == other.notes &&
          creatorId == other.creatorId &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        Object.hashAll(contactIds),
        Object.hashAll(groupIds),
        archetypeId,
        checklist,
        Object.hashAll(rootNodeIds),
        latestSoftwareUpdate,
        warranty,
        Object.hashAll(files),
        customFields,
        notes,
        creatorId,
        created,
        updated,
      ]);
}

/// Helper for the `systems` collection.
abstract final class Systems {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'systems';

  ///Gets the [CollectionHelper] for the `systems` collection
  static CollectionHelper<System> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'systems',
        mapper: System.fromMap,
      );

  /// Access the file api for the `files` field
  MultiFileHelper<System> filesApi(String id) => FileHelper<System>(
        collection: 'systems',
        id: id,
        field: 'files',
        mapper: System.fromMap,
      );
}

/// Model for the `tags` collection.
class Tag implements PocketBaseRecord {
  Tag({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.type,
    required this.created,
    required this.updated,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: (map['id'] as String),
      name: (map['name'] as String),
      description: (map['description'] as String?),
      color: map['color'] != null ? (map['color'] as num).toDouble() : null,
      type: (map['type'] as String),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final String? description;

  final double? color;

  final String type;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'tags',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'color': color,
        'type': type,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  Tag copyWith({
    String? id,
    String? name,
    String? description,
    double? color,
    String? type,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      type: type ?? this.type,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          type == other.type &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        description,
        color,
        type,
        created,
        updated,
      ]);
}

/// Helper for the `tags` collection.
abstract final class Tags {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'tags';

  ///Gets the [CollectionHelper] for the `tags` collection
  static CollectionHelper<Tag> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'tags',
        mapper: Tag.fromMap,
      );
}

/// Model for the `checklist_table` collection.
class ChecklistTable implements PocketBaseRecord {
  ChecklistTable({
    required this.id,
    required this.name,
    required this.created,
    required this.updated,
  });

  factory ChecklistTable.fromMap(Map<String, dynamic> map) {
    return ChecklistTable(
      id: (map['id'] as String),
      name: (map['name'] as String),
      created: DateTime.parse((map['created'] as String)),
      updated: DateTime.parse((map['updated'] as String)),
    );
  }

  @override
  final String id;

  final String name;

  final DateTime created;

  final DateTime updated;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'checklist_table',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'created': created.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  ChecklistTable copyWith({
    String? id,
    String? name,
  }) {
    return ChecklistTable(
      id: id ?? this.id,
      name: name ?? this.name,
      created: created,
      updated: updated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is ChecklistTable &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          created == other.created &&
          updated == other.updated;

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        created,
        updated,
      ]);
}

/// Helper for the `checklist_table` collection.
abstract final class ChecklistTables {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'checklist_table';

  ///Gets the [CollectionHelper] for the `checklist_table` collection
  static CollectionHelper<ChecklistTable> api(
          [PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'checklist_table',
        mapper: ChecklistTable.fromMap,
      );
}

/// Model for the `stock_table` collection.
class StockTable implements PocketBaseRecord {
  StockTable({
    required this.id,
    this.thumbnail,
    required this.name,
    required this.categoryIds,
    this.sku,
    this.manufacturer,
    this.customFields,
    this.stockCount,
    this.totalStockCount,
    this.deployedCount,
    this.lowStockCutoff,
    required this.updated,
    required this.created,
  });

  factory StockTable.fromMap(Map<String, dynamic> map) {
    return StockTable(
      id: (map['id'] as String),
      thumbnail: (map['thumbnail'] as String?),
      name: (map['name'] as String),
      categoryIds: (map['category_ids'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      sku: (map['sku'] as String?),
      manufacturer: (map['manufacturer'] as String?),
      customFields: map['custom_fields'],
      stockCount: map['stock_count'] != null
          ? (map['stock_count'] as num).toDouble()
          : null,
      totalStockCount: map['total_stock_count'],
      deployedCount: map['deployed_count'] != null
          ? (map['deployed_count'] as num).toDouble()
          : null,
      lowStockCutoff: map['low_stock_cutoff'] != null
          ? (map['low_stock_cutoff'] as num).toDouble()
          : null,
      updated: DateTime.parse((map['updated'] as String)),
      created: DateTime.parse((map['created'] as String)),
    );
  }

  @override
  final String id;

  final String? thumbnail;

  final String name;

  final List<String> categoryIds;

  final String? sku;

  final String? manufacturer;

  final dynamic customFields;

  final double? stockCount;

  final dynamic totalStockCount;

  final double? deployedCount;

  final double? lowStockCutoff;

  final DateTime updated;

  final DateTime created;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'stock_table',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'thumbnail': thumbnail,
        'name': name,
        'category_ids': categoryIds,
        'sku': sku,
        'manufacturer': manufacturer,
        'custom_fields': customFields,
        'stock_count': stockCount,
        'total_stock_count': totalStockCount,
        'deployed_count': deployedCount,
        'low_stock_cutoff': lowStockCutoff,
        'updated': updated.toIso8601String(),
        'created': created.toIso8601String(),
      };

  StockTable copyWith({
    String? id,
    String? thumbnail,
    String? name,
    List<String>? categoryIds,
    String? sku,
    String? manufacturer,
    dynamic customFields,
    double? stockCount,
    dynamic totalStockCount,
    double? deployedCount,
    double? lowStockCutoff,
  }) {
    return StockTable(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      name: name ?? this.name,
      categoryIds: categoryIds ?? this.categoryIds,
      sku: sku ?? this.sku,
      manufacturer: manufacturer ?? this.manufacturer,
      customFields: customFields ?? this.customFields,
      stockCount: stockCount ?? this.stockCount,
      totalStockCount: totalStockCount ?? this.totalStockCount,
      deployedCount: deployedCount ?? this.deployedCount,
      lowStockCutoff: lowStockCutoff ?? this.lowStockCutoff,
      updated: updated,
      created: created,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is StockTable &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          thumbnail == other.thumbnail &&
          name == other.name &&
          _listEquals(
            categoryIds,
            other.categoryIds,
          ) &&
          sku == other.sku &&
          manufacturer == other.manufacturer &&
          customFields == other.customFields &&
          stockCount == other.stockCount &&
          totalStockCount == other.totalStockCount &&
          deployedCount == other.deployedCount &&
          lowStockCutoff == other.lowStockCutoff &&
          updated == other.updated &&
          created == other.created;

  @override
  int get hashCode => Object.hashAll([
        id,
        thumbnail,
        name,
        Object.hashAll(categoryIds),
        sku,
        manufacturer,
        customFields,
        stockCount,
        totalStockCount,
        deployedCount,
        lowStockCutoff,
        updated,
        created,
      ]);
}

/// Helper for the `stock_table` collection.
abstract final class StockTables {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'stock_table';

  ///Gets the [CollectionHelper] for the `stock_table` collection
  static CollectionHelper<StockTable> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'stock_table',
        mapper: StockTable.fromMap,
      );

  /// Access the file api for the `thumbnail` field
  SingleFileHelper<StockTable> thumbnailApi(String id) =>
      FileHelper<StockTable>(
        collection: 'stock_table',
        id: id,
        field: 'thumbnail',
        mapper: StockTable.fromMap,
      );
}

/// Model for the `system_stock_table` collection.
class SystemStockTable implements PocketBaseRecord {
  SystemStockTable({
    required this.id,
    this.thumbnail,
    this.title,
    this.deployedCount,
    required this.updated,
    required this.created,
  });

  factory SystemStockTable.fromMap(Map<String, dynamic> map) {
    return SystemStockTable(
      id: (map['id'] as String),
      thumbnail: (map['thumbnail'] as String?),
      title: (map['title'] as String?),
      deployedCount: map['deployed_count'] != null
          ? (map['deployed_count'] as num).toDouble()
          : null,
      updated: DateTime.parse((map['updated'] as String)),
      created: DateTime.parse((map['created'] as String)),
    );
  }

  @override
  final String id;

  final String? thumbnail;

  final String? title;

  final double? deployedCount;

  final DateTime updated;

  final DateTime created;

  /// Get a file attached to this record with the name [fileName]
  Uri getFileUrl({
    required String fileName,
    PocketBase? pocketBaseInstance,
  }) =>
      HelperUtils.buildFileUrl(
        'system_stock_table',
        id,
        fileName,
        pocketBaseInstance: pocketBaseInstance,
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'thumbnail': thumbnail,
        'title': title,
        'deployed_count': deployedCount,
        'updated': updated.toIso8601String(),
        'created': created.toIso8601String(),
      };

  SystemStockTable copyWith({
    String? id,
    String? thumbnail,
    String? title,
    double? deployedCount,
  }) {
    return SystemStockTable(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      deployedCount: deployedCount ?? this.deployedCount,
      updated: updated,
      created: created,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(
        this,
        other,
      ) ||
      other is SystemStockTable &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          thumbnail == other.thumbnail &&
          title == other.title &&
          deployedCount == other.deployedCount &&
          updated == other.updated &&
          created == other.created;

  @override
  int get hashCode => Object.hashAll([
        id,
        thumbnail,
        title,
        deployedCount,
        updated,
        created,
      ]);
}

/// Helper for the `system_stock_table` collection.
abstract final class SystemStockTables {
  /// The name of this collection in PocketBase.
  static const String collectionName = 'system_stock_table';

  ///Gets the [CollectionHelper] for the `system_stock_table` collection
  static CollectionHelper<SystemStockTable> api(
          [PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'system_stock_table',
        mapper: SystemStockTable.fromMap,
      );

  /// Access the file api for the `thumbnail` field
  SingleFileHelper<SystemStockTable> thumbnailApi(String id) =>
      FileHelper<SystemStockTable>(
        collection: 'system_stock_table',
        id: id,
        field: 'thumbnail',
        mapper: SystemStockTable.fromMap,
      );
}

/// Static class containing all the string literals for your pocketbase collections.
abstract final class Collection {
  /// The name of the `users` collection.
  static const String users = 'users';

  /// The name of the `address_book` collection.
  static const String addressBooks = 'address_book';

  /// The name of the `archetype_nodes` collection.
  static const String archetypeNodes = 'archetype_nodes';

  /// The name of the `archetypes` collection.
  static const String archetypes = 'archetypes';

  /// The name of the `categories` collection.
  static const String categories = 'categories';

  /// The name of the `checklists` collection.
  static const String checklists = 'checklists';

  /// The name of the `configuration` collection.
  static const String configurations = 'configuration';

  /// The name of the `contacts` collection.
  static const String contacts = 'contacts';

  /// The name of the `groups` collection.
  static const String groups = 'groups';

  /// The name of the `issues` collection.
  static const String issues = 'issues';

  /// The name of the `part_nodes` collection.
  static const String partNodes = 'part_nodes';

  /// The name of the `parts` collection.
  static const String parts = 'parts';

  /// The name of the `shipments` collection.
  static const String shipments = 'shipments';

  /// The name of the `system_archetypes` collection.
  static const String systemArchetypes = 'system_archetypes';

  /// The name of the `systems` collection.
  static const String systems = 'systems';

  /// The name of the `tags` collection.
  static const String tags = 'tags';

  /// The name of the `checklist_table` collection.
  static const String checklistTables = 'checklist_table';

  /// The name of the `stock_table` collection.
  static const String stockTables = 'stock_table';

  /// The name of the `system_stock_table` collection.
  static const String systemStockTables = 'system_stock_table';
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
