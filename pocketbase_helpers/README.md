# pocketbase_helpers

A Dart package that simplifies working with **PocketBase** using **type-safe Dart models**.

It provides helpers for collections, authentication, connection management, search utilities, file handling, and relation expansion.

The package is modular, you can use only the parts you need.

---

# Features

- Type-safe models generated from PocketBase schema
- Concise collection API wrapper
- Authentication helpers
- File and relation utilities
- Keyword search across multiple fields
- Connection manager with lifecycle hooks
- Modular architecture

---

# Quick Start

## 1. Install the package

```
dart pub add pocketbase pocketbase_helpers
```

## 2. Generate Models (Recommended)

Before writing any code, generate Dart models from your PocketBase schema.

Install the CLI:

```bash
dart pub global activate pocketbase_helpers_cli
```

Generate models:

```bash
pb_generate -s pb_schema.json -o lib/models.dart
```

This generates strongly typed models with built-in API helpers.

## 3. Use Your Generated Models

You can use your models by opening a connection and calling the api.

```dart
import 'models.dart';

void main() async {
  PocketBaseConnection.open('http://127.0.0.1:8090');

  final users = await Users.api().getFullList();

  final blog = await Blogs.api().create(
    data: {'title': 'Powering flutter apps with pocketbase!'},
  );

  //Connection should be closed at the end of your program
  PocketBaseConnection.close();
}
```

This is all you need to get started with this package, but if you want to learn about all the cool features this package has keep on reading!

---

# Mental Model

When using this package there are **four main pieces**:

| Component                                                            | Purpose                                                     |
| -------------------------------------------------------------------- | ----------------------------------------------------------- |
| **PocketBaseConnection**                                             | Manages the global PocketBase instance                      |
| **Model (`User`)**                                                   | Represents a single database record                         |
| **Collection API (`Users`)**                                         | Provides static helpers for interacting with the collection |
| **CollectionHelper**, **AuthHelper**, **FileHelper**, **BaseHelper** | The underlying helpers that make the api calls              |

Example flow:

```
Users.api().getFullList()
```

1. `Users.api()` returns a `CollectionHelper<User>`
2. The helper performs the query through PocketBase
3. Results are mapped to `User` models

These components can be mixed and matched, if you dont use the generator you can ignore the Model and CollectionAPI components. If you have your own `PocketBase` instance you can ignore the `PocketBaseConnection` component.

---

# Index

- [Quick Start](#quick-start)
- [Mental Model](#mental-model)
- [Connection Management](#connection-management)
  - [PocketBaseConnection](#pocketbaseconnection)
  - [Connection Hooks](#connection-hooks)
- [Generated Models](#generated-models)
  - [Entity Model](#entity-model)
  - [Collection API](#collection-api)
  - [Generated Static Methods](#generated-static-methods)
- [Collection API](#collection-api)
- [CRUD Operations](#crud-operations)
- [Querying Data](#querying-data)
- [Authentication](#authentication)
- [Searching](#searching)
- [File Handling](#file-handling)
- [Relation Expansions](#relation-expansions)
- [Manual Models](#manual-models)
- [Low-Level API](#low-level-api)
- [Utilities](#utilities)
- [Modular Usage](#modular-usage)
- [License](#license)

---

# Connection Management

## PocketBaseConnection

`PocketBaseConnection` manages a shared PocketBase instance.

```dart
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  lang: 'en-US',
  authStore: persistentAuthStore,
);
```

Access the active connection:

```dart
final pb = PocketBaseConnection.pb;
```

Close it when the application shuts down:

```dart
PocketBaseConnection.close();
```

---

## Connection Hooks

Hooks allow modifying data before create or update.

```dart
PocketBaseConnection.setHooks(
  preCreationHook: (collection, pb, map) {
    if (pb.authStore.isValid) {
      map['created_by'] = pb.authStore.record?.id;
    }
    return map;
  },
  preUpdateHook: (collection, pb, map) {
    if (pb.authStore.isValid) {
      map['updated_by'] = pb.authStore.record?.id;
    }
    return map;
  },
);
```

Reset hooks by returning the map immediately.

---

# Generated Models

The CLI generates **two classes per collection**.

| Class   | Purpose                                               |
| ------- | ----------------------------------------------------- |
| `User`  | Data model representing a record                      |
| `Users` | Static API helper for interacting with the collection |

Example for a `users` collection.

---

## Entity Model

The entity represents a record in the database. Below is an example of what such a record looks like.

```dart
class User implements PocketBaseRecord {
  final String id;
  final String email;

  factory User.fromMap(Map<String,dynamic> map);

  Map<String,dynamic> toMap();

  Url getFileUrl(String fileName);
}
```

Responsibilities:

- Store record data
- Convert between Dart objects and PocketBase JSON

---

## Collection API

The generator creates a companion class exposing static helpers.

```dart
final users = Users.api();
```

This returns a configured `CollectionHelper<User>`.

Equivalent manual setup:

```dart
CollectionHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'users',
  mapper: User.fromMap,
);
```

---

## Generated Static Methods

### `api()`

Returns a `CollectionHelper` for the collection.

```dart
final users = Users.api();
```

---

### `auth()`

Returns an authentication helper.

```dart
await Users.auth().withPassword(email, password);
```

Only available for auth collections.

---

### File Field APIs

Each file field generates a helper method.

Example:

```dart
Users.avatarApi(userId);
```

This returns a `FileHelper`.

---

# Collection API

`CollectionHelper` performs database operations for a collection.

Generated models expose it through `.api()`.

```dart
final users = Users.api();
```

---

## CRUD Operations

```dart
// fetch one
final user = await Users.api().getOne(id);

// fetch multiple
final users = await Users.api().getMultiple([id1, id2]);

// create
final newUser = await Users.api().create(data: {
  'email': 'user@example.com'
});

// update
await Users.api().update(
  user.copyWith(name: 'Jane')
);

// delete
await Users.api().delete(user.id);
```

---

# Querying Data

```dart
// Get a paginated list
await Users.api().getList(
  page: 1,
  perPage: 20,
  sort: '-created',
);
// get a full list
await Users.api().getFullList();
// get the first record matching the query or null if there was no match
await Users.api().getOneOrNull();
// count the records matching the query
await Users.api().count();
```

---

## Filtering

All queries support PocketBase filter and sorting expressions.

```dart
await Users.api().getList(
  expr: 'active = {:active}',
  params: {'active': true},
  sort: '-created,name',
);
```

---

# Authentication

Authentication is handled through `AuthHelper`.

```dart
final result = await Users.auth()
  .withPassword(email, password);

print(result.status);
print(result.record);
```

All authentication methods from the PocketBase SDK are supported.

---

# Searching

Search keywords across multiple fields.

```dart
await Products.api().search(
  keywords: ['phone', 'apple'],
  searchableFields: ['name','description'],
  page: 1,
  perPage: 20,
);
```

Additional filters can be added.

```dart
await Products.api().search(
  keywords: ['laptop'],
  searchableFields: ['name','description'],
  additionalExpressions: ['price > {:minPrice}'],
  additionalParams: {'minPrice': 500},
);
```

---

# File Handling

File fields are managed through `FileHelper`.

Generated helpers:

```dart
final avatar = Users.avatarApi(user.id);
```

Manual helper:

```dart
final avatar = Users.api().fileField(user.id, 'avatar');
```

Set a file:

```dart
await avatar.set('photo.jpg', bytes);
```

Remove a file:

```dart
await avatar.unset();
```

Multiple files:

```dart
await gallery.add('image1.jpg', bytes);
await gallery.remove('image1.jpg');
await gallery.removeAll();
```

File URLs:

```dart
user.getFileUrl(user.avatar);

Users.api().buildFileUrl(user.id, user.avatar);
```

---

# Relation Expansions

PocketBase supports expanding relations.

Models can map these directly.

Example:

```dart
class Post implements PocketBaseRecord {
  final String id;
  final String userId;
  final User user;
}
```

Configure mapping:

```dart
CollectionHelper(
  pocketBaseInstance: pb,
  collection: 'posts',
  mapper: Post.fromMap,
  expansions: {'user_id': 'user'},
);
```

Query:

```dart
final post = await helper.getOne(postId);

print(post.user.name);
```

Additional expansions can be specified per query.

---

# Manual Models

Helpers can also be used without the generator.

```dart
class User implements PocketBaseRecord {

  final String id;
  final String email;

  static User fromMap(Map<String,dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
    );
  }

  @override
  Map<String,dynamic> toMap() => {
    'id': id,
    'email': email,
  };
}
```

Create a helper:

```dart
CollectionHelper(
  pocketBaseInstance: PocketBase('http://127.0.0.1:8090'),
  collection: 'users',
  mapper: User.fromMap,
);
```

---

# Low-Level API

`BaseHelper` provides minimal wrappers around PocketBase.

```dart
final helper = BaseHelper(
  pocketBaseInstance: pb,
);

await helper.getFullList(
  'users',
  mapper: User.fromMap,
);
```

---

# Utilities

`HelperUtils` contains helper functions.

```dart
// clean up a map, prunes empty strings and maps to work with dart null safety.
HelperUtils.cleanMap(rawMap);

// gets file names from a list of file urls
HelperUtils.getNamesFromUrls(urls);

// builds a sort string for sorting by a singular field.
HelperUtils.buildSortString('created', false);

// builds the expression and escaped parameters to preform a search query
// requires a list of keywords and searchable fields as parameters.
final (expr, params) = HelperUtils.buildQuery(
  ['apple','phone'],
  ['name','description'],
);

// build a file url for a file on a record
HelperUtils.buildFileUrl(collection, recordId, fileName);
```

---

# Modular Usage

You can use individual components if desired.

Full stack:

```dart
PocketBaseConnection.open(url);

await Users.api().getFullList();
```

Collection helper only:

```dart
CollectionHelper(...);
```

Low-level API:

```dart
BaseHelper(...);
```

Utilities only:

```dart
HelperUtils.cleanMap(data);
```

---

# License

MIT licensed.

Contributions and pull requests are welcome.

---

If you'd like, I can also show **one documentation trick that dramatically improves pub.dev readability**: splitting the docs into **"Guide" + "API Reference" sections**, which makes packages feel much more polished and easier to navigate.
