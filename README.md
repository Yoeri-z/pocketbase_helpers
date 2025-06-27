# pocketbase_helpers

A package to make working with PocketBase easier when using serializable models in Dart. It also adds a utility for keyword searching on your collections.

## Motivation

PocketBase is a great backend for Flutter — lightweight, easy to use, and highly extendable. However, the base [`pocketbase`](https://pub.dev/packages/pocketbase) package does not provide utilities for strongly typed data, which is one of Dart’s main strengths over JavaScript.

This package simplifies working with typed data and handles PocketBase's quirks (like empty strings instead of `null`) more gracefully.

### Without pocketbase_helpers:

```dart
Future<TypedResultList<MyRecord>> getOpenRecords() async {
  final filter = pb.filter('status = {:status}', {'status': 'open'});

  final result = await pb.collection('my_collection').getList(filter: filter);

  return TypedResultList(
    result.items.map((record) => MyRecord.fromJson(
      // Remove empty strings to prevent parse errors
      pruneEmptyStrings(record.toJson()),
    )).toList(),
    page: result.page,
    perPage: result.perPage,
    totalItems: result.totalItems,
    totalPages: result.totalPages,
  );
}
```

### With pocketbase_helpers:

```dart
Future<TypedResultList<MyRecord>> getOpenRecords() async {
  return helper.getList(
        expr: 'status = {:status}', 
        params: {'status': 'open'},
    );
}
```

## Getting Started

### Creating a CollectionHelper:

```dart
final helper = CollectionHelper(
  pb //your pocketbase instance,
  collection: 'my_collection',
  mapper: MyRecord.fromMap,
);
```

Ensure your models implement `PocketBaseRecord`:

```dart
class MyRecord implements PocketBaseRecord {
  // your model code
}
```

You can use any serializer that converts a `Map<String, dynamic>` to your model.

### Available Methods

```dart
// paginated list fetch
final paginatedList = await helper.getList();

// Fetch full list
final list = await helper.getFullList();

// Search and sort-friendly paginated fetch
// allows you to do keyword searches, see inline documentation for more information
final paginatedList = await helper.search(
  params: params,
  searchableColumns: [...],
);

// CRUD operations
final record = await helper.getSingle(id);
final record = await helper.create(data: data);
final record = await helper.update(record);
await helper.delete(id);

// File utilities
final uri = helper.getFileUri(id, filename);
final record = await helper.addFiles(id, filePaths: [...]);
final record = await helper.removeFiles(id, fileUrls: [...]);
```

### Merging expansions:
Pocketbase allows you to expand foreign fields in your records,
this package adds a utility to automatically remap these expansions to be put in your model classes:
```dart
class User implements PocketbaseRecord{
  @override
  final String id;
  final String username;

  // rest of your model code
}

class Post implements PocketBaseRecord {
  @override
  final String id;
  final String userId;
  final User user;

  // rest of your model code
}

//setup a helper with some base expansions
final helper = CollectionHelper(
  pb //your pocketbase instance,
  collection: 'posts',
  mapper: MyRecord.fromMap,
  baseExpansions: {
    'user_id' : 'user'
  },
);

//now all the methods with this helper will automatically include the user field
final post = await 
```

## Other Utilities

### BaseHelper

A more flexible helper where `collection` and `mapper` are specified per method. Useful for dynamic or multi-collection use cases.

### HelperUtils

Contains static methods for building queries (mainly used internally, but also available).

Also allows two hooks to be registered, a creation hook and an update hook, allowing you to modify the json/map directly before it is sent to the server

```dart
void registerHooks() {
  HelperUtils.creationHook = (collection, pb, map) {
    if (pb.authStore.isValid) {
      //store the creator of every record
      map['creator_id'] = pb.authStore.record?.id;
    }
    return map;
  };

  HelperUtils.updateHook = (collection, pb, map) {
    print('updated something');
    return map;
  };
}
```

## License and Contributing

MIT licensed. Contributions are welcome — feel free to open issues or submit PRs.
