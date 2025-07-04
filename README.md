# pocketbase_helpers

A package to make working with PocketBase easier when using serializable models in Dart. It also adds a utility for keyword searching on your collections.

## Motivation

PocketBase is a great backend for Flutter — lightweight, easy to use, and highly extendable. However, the base [`pocketbase`](https://pub.dev/packages/pocketbase) package does not provide a lot of utilities for strongly typed data, which is one of Dart’s main strengths over JavaScript.

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
final paginatedList = await helper.getList(
  //expr fields take a pocketbase expression
  expr: 'status = {:status}',

  //params can be optionally supplied to escape values
  params: {'status' : 'open'}

  //a regular pocketbase sort string
  sort: 'title,-status'

  //optionally limit the number of fields that is included in the result
  //if left empty all fields are returned
  fields: ['id', 'title', 'status']
  //also has header and query fields to add those to your request
  headers: {}
  query: {}
);

// Fetch full list
final list = await helper.getFullList(
  //same parameters as helper.getList()
);

// Keyword Search paginated fetch
// takes a string query and a list of fields that may be searched
final paginatedList = await helper.search(
  searchQuery: query,
  searchableFields: [...],
  //same parameters as helper.getList()
);

// CRUD operations
final record = await helper.getSingle(id);
final maybeRecord = await helper.getMaybeSingle(id);
final record = await helper.create(data: data);
final record = await helper.update(record);
await helper.delete(id);

// File utilities
final uri = helper.getFileUrl(id, filename);
final record = await helper.addFiles(id, files: [...]);
final record = await helper.removeFiles(id, fileNames: [...]);
```

### Merging expansions:
Pocketbase allows you to expand foreign fields in your records,
this package adds a utility to automatically remap these expansions to be put in your model classes:
```dart
class User implements PocketbaseRecord{
  @override
  final String id;
  final String name;

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
  expansions: {
    'user_id' : 'user'
  },
);

//now all the methods with this helper will automatically include the user field
final post = await helper.getSingle(postId);
print(post.user.name)


//to include more expansions on a per method basis use the [additionalExpansions] field:
final post = await helper.getSingle(postId, additionalExpansions: {
  'category_id' : 'category'
});
print(post.user.name)
print(post.category.title)
```

## Other Utilities

### BaseHelper

A more flexible helper where `collection` and `mapper` are specified per method. Useful for dynamic or multi-collection use cases.

### HelperUtils

Contains a few usefull static methods (but also available):
```dart
//Method to clean up maps received form the pocketbase package
//removes empty string values to make it work with dart nullsafety
final map = HelperUtils.cleanMap(map)

//Gets the names of files from their urls, this is simply the last path segment
final names = HelperUtils.getNamesFromUrls(fileUrls)
//usefull together with the removefiles method:
helper.removeFiles(id, fileNames: names)

///Convert local filepaths into a correctly formatted filemap that is required by the addFiles method
///This method does not work for Web and WILL throw an error.
final files = HelperUtils.pathsToFiles(paths)
//usefull together with the addfiles method:
helper.addFiles(id, files: files)

//builds a sort string for a single field
final sort = HelperUtils.buildSortString(field, ascending)

//build an advanced keyword search, returns an expressions and escaped parameters
(String expr, Map<String, dynamic> params) buildQuery(
    ///the keywords to search for, will be comma seperated
    String query,
    ///the fields on your collection to look for this keyword
    List<String> searchableFields, {
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
  })

//can be put into a pocketbase filter:
final filter = pb.filter(expr, params)
```

Also allows two hooks to be registered, a creation hook and an update hook, allowing you to modify the json/map directly before it is sent to the server

```dart
void registerHooks() {
  HelperUtils.preCreationHook = (collection, pb, map) {
    if (pb.authStore.isValid) {
      //store the creator of every record
      map['creator_id'] = pb.authStore.record?.id;
    }
    return map;
  };

  HelperUtils.preUpdateHook = (collection, pb, map) {
    print('updated something');
    return map;
  };
}
```

## License and Contributing

MIT licensed. Contributions are welcome — feel free to open issues or submit PRs.
