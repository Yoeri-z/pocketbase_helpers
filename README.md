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
// CRUD operations (here record is one of your serializable models)
MyRecord record = await helper.getOne(id);
MyRecord record = await helper.getMultiple([id1, id2, ...]);
MyRecord record = await helper.create(data: data);
MyRecord record = await helper.update(record);
await helper.delete(id);

// Operations with filter options
TypedResultList<MyRecord> paginatedList = await helper.getList();
List<MyRecord> list = await helper.getFullList();
MyRecord? maybeRecord = await helper.getOneOrNull();
TypedResultList<MyRecord> paginatedList = await helper.search(
  //search for records containing all the keywords
  keywords: [...],
  searchableFields: [...],
);
int count = await helper.count();


// File Operations
//get the uri for a file
final uri = helper.buildFileUrl(recordId, fileName);

//get the file field to change the files attached to it.
final fileField = helper.fileField(id, fieldName);

//single file field
await fileField.set(name, data);
await fileField.unset();

//multi file field
await fileField.add(name, data);
await filefield.addMany({
  name1 : name1Data,
  name2: name2Data,
  ...
})
await fileField.remove(name);
await fileField.removeMany({
  [name1, name2, name3 ...]
});
await fileField.removeAll();

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
  mapper: Post.fromMap,
  expansions: {
    'user_id' : 'user'
  },
);

//now all the methods with this helper will automatically include the user field
final post = await helper.getOne(postId);
print(post.user.name)


//to include more expansions on a per method basis use the [additionalExpansions] field:
final post = await helper.getOne(postId, additionalExpansions: {
  'category_id' : 'category'
});
print(post.user.name)
print(post.category.title)
```

## Other Utilities

### BaseHelper

A low level helper where `collection` and `mapper` are specified per method, useful when your dart model does not confirm to the `PocketBaseRecord` interface.

### HelperUtils

Contains a few usefull static methods:

```dart
//Method to clean up maps received form the pocketbase package
final map = HelperUtils.cleanMap(map);

//Gets the names of files from their urls
final names = HelperUtils.getNamesFromUrls(fileUrls);
//usefull together with the removefiles method:
helper.removeFiles(id, fileNames: names);

///Convert local filepaths into a correctly formatted filemap that is required by the addFiles method
///This method does not work for Web and WILL throw an error.
final files = HelperUtils.pathsToFiles(paths);
//usefull together with the addfiles method:
helper.addFiles(id, files: files);

//builds a sort string for a single field
final sort = HelperUtils.buildSortString(field, ascending);

//build an advanced keyword search query, returns an expressions and escaped parameters
final (expr, params) = HelperUtils.buildQuery(
    ///the keywords to search for, will be comma seperated
    [...],
    ///the fields on your collection to look for this keyword
    [...],
);

//can be put into a pocketbase filter:
final filter = pb.filter(expr, params);
```

`HelperUtils` also allows two hooks to be registered, a creation hook and an update hook, allowing you to modify the raw json/map directly before it is sent to the server

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

## Testing

This package also provides a testing utility that easily allows you to test and intercept pocketbase calls, check incoming parameters, create mocks and return fake outputs.

It works like this:

```dart
//define a handler for a collection
class MyFakeHandler extends MockHandler{
  @override
  String get

}

```

## License and Contributing

MIT licensed. Contributions are welcome — feel free to open issues or submit PRs.
This package is in very early development phase, use at your own risk.
