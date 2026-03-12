# pocketbase_helpers

A Dart package that simplifies working with **[PocketBase](https://pocketbase.io)** using **type-safe models**.
It provides helpers for collections, connection management, search utilities, file handling, and relation expansion.

The package is modular, you can use only the parts you need.

---

# Features

- **Type Safety** – Generated models with strong typing
- **Connection Manager** – Simple global PocketBase instance
- **Collection Helpers** – Concise type safe API wrappers over the pocketbase sdk
- **Advanced Search** – Keyword search across multiple fields
- **File & Relation Utilities** – Simplified file and expansion handling
- **Hooks** – Automatically modify data before create/update
- **Modular Design** – Use helpers independently if needed
- **One-Liner Operations** – Common database operations with minimal code

---

# Quick Start

## 1. Generate Models (Recommended)

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

Example generated usage:

```dart
final users = await Users.api().getFullList();
```

If you want to use your own pocketbase instance:

```dart
final pb = PocketBase('http://127.0.0.1:8090');
final users = await Users.api(pb).getFullList();
```

---

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

  PocketBaseConnection.close();
}
```

This is all you need to get started with this package, but if you want to learn about all the cool features this package has keep on reading!

---

# CollectionHelper

`CollectionHelper` is the main interface used to interact with PocketBase collections.

All generated models expose a static `.api()` method that simply returns a configured `CollectionHelper` for that collection.

Example:

```dart
final users = Users.api();
```

This is equivalent to manually creating the helper:

```dart
final users = CollectionHelper(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'users',
  mapper: Users.fromMap,
);
```

Once you have a `CollectionHelper`, you can perform all pocketbase operations:

```dart
final users = Users.api();

// fetch
final list = await users.getFullList();

// fetch single record
final user = await users.getOne('record_id');

// create
final newUser = await users.create(
  data: {'email': 'test@example.com'},
);

// update
await users.update(user.copyWith(name: 'Jane'));

// delete
await users.delete(user.id);
```

---

# Authenticating

All methods related to authenticating are available through the AuthHelper, similarly to CollectionHelper it will be generated when using the cli.
You can also create an `AuthHelper` yourself by calling its constructor.

```dart
import 'models.dart';

void main() async {
  PocketBaseConnection.open('http://127.0.0.1:8090');

  final result = await Users.auth().withPassword('johndoe@gmail.com', 'verysecretpassword');

  // status of the http request
  print(result.status);
  // authenticated record, only available if status was ok
  print(result.record);

  PocketBaseConnection.close();
}
```

The `AuthHelper` has all the same methods for authenticating as the regular pocketbase sdk.

# Connection Management

## PocketBaseConnection

The connection manager provides a single shared PocketBase instance.

```dart
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  lang: 'en-US',
  authStore: persistenAuthStore,

);
```

Access the active PocketBase instance:

```dart
final pb = PocketBaseConnection.pb;
```

Close the connection when the application shuts down:

```dart
PocketBaseConnection.close();
```

Default address if none is specified:

```dart
PocketBaseConnection.defaultAddress;
// http://localhost:8090
```

---

## Connection Hooks

Hooks allow automatically modifying data before create/update.

```dart
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
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

---

# CRUD Operations

```dart
// Fetch record
final user = await Users.api().getOne('record_id');

// Fetch multiple
final users = await Users.api().getMultiple(['id1', 'id2']);

// Create
final newUser = await Users.api().create(data: {
  'email': 'user@example.com',
  'name': 'John Doe'
});

// Update
final updated = await Users.api().update(
  user.copyWith(name: 'Jane Doe')
);

// Delete
await Users.api().delete('record_id');
```

---

# Query Operations

```dart
// Paginated
final page = await Users.api().getList(
  page: 1,
  perPage: 20,
  sort: '-created',
);

// All records
final users = await Users.api().getFullList();

// Optional fetch
final user = await Users.api().getOneOrNull();

// Count
final count = await Users.api().count();
```

---

# Filtering & Sorting

All query operations can be filtered like this:

```dart
final users = await Users.api().getList(
  expr: 'active = {:active}',
  params: {'active': true},
);

final users = await Users.api().getList(
  sort: '-created,name',
);
```

---

# Advanced Search

Search keywords across multiple fields. This is not a pocketbase native operation,
the package breaks the search query down into a big filter and uses that with the regular api.

```dart
final results = await Products.api().search(
  keywords: ['phone', 'apple'],
  searchableFields: ['name', 'description'],
  page: 1,
  perPage: 20,
);
```

Additional filters:

```dart
final results = await Products.api().search(
  keywords: ['laptop'],
  searchableFields: ['name', 'description'],
  additionalExpressions: [
    'price > {:minPrice}',
    'in_stock = {:inStock}'
  ],
  additionalParams: {
    'minPrice': 500,
    'inStock': true
  },
);
```

---

# File Operations

Single File operations:

```dart
// Build file URL
final url = Users.api().buildFileUrl('user_id', 'avatar.jpg');

// File field
final avatar = Users.api().fileField('user_id', 'avatar');

await avatar.set('profile.jpg', bytes);
await avatar.unset();
```

Multiple files:

```dart
final gallery = Posts.api().fileField('post_id', 'images');

await gallery.add('image1.jpg', bytes);

await gallery.addMany({
  'image2.jpg': bytes,
  'image3.jpg': bytes
});

await gallery.remove('image1.jpg');
await gallery.removeAll();
```

---

# Relation Expansions

PocketBase allows expanding relations.

`pocketbase_helpers` can automatically map those to model fields. This feature only works when you make your own custom models.

Example models:

```dart
class User implements PocketBaseRecord {
  final String id;
  final String name;
}

class Post implements PocketBaseRecord {
  final String id;
  final String userId;
  final User user;
}
```

Configure helper:

```dart
final helper = CollectionHelper(
  pocketBaseInstance: pb,
  collection: 'posts',
  mapper: Post.fromMap,
  expansions: {
    'user_id': 'user'
  },
);
```

Now expansions are automatic:

```dart
final post = await helper.getOne(postId);

print(post.user.name);
```

Additional expansions per query:

```dart
final post = await helper.getOne(
  postId,
  additionalExpansions: {
    'category_id': 'category'
  },
);
```

---

# Using Without Generated Models

You can also use helpers with manual models.

```dart
class User implements PocketBaseRecord {

  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  static User fromMap(Map<String,dynamic> map){
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

Create helper:

```dart
final helper = CollectionHelper(
  pocketBaseInstance: PocketBase('http://127.0.0.1:8090'),
  collection: 'users',
  mapper: User.fromMap,
);
```

---

# Low-Level API

## BaseHelper

Use `BaseHelper` for maximum flexibility.

```dart
final pb = PocketBase('http://127.0.0.1:8090');

final helper = BaseHelper(
  pocketBaseInstance: pb,
);

final users = await helper.getFullList(
  'users',
  mapper: User.fromMap,
);
```

---

# Utilities

`HelperUtils` contains useful helpers.

```dart
HelperUtils.cleanMap(rawMap);

HelperUtils.getNamesFromUrls([
  'http://localhost:8090/api/files/...'
]);

HelperUtils.buildSortString('created', false);

final (expr, params) = HelperUtils.buildQuery(
  ['apple','phone'],
  ['name','description'],
);
```

---

# Modular Usage

You can use only the parts you need.

### Full stack

```dart
PocketBaseConnection.open(url);
final users = await Users.api().getFullList();
```

### Only CollectionHelper

```dart
final helper = CollectionHelper(...);
```

### Only BaseHelper

```dart
final helper = BaseHelper(...);
```

### Only Utilities

```dart
HelperUtils.cleanMap(data);
```

---

# Why Use pocketbase_helpers

### Type Safety

Generated models give compile-time safety and autocomplete.

### Developer Productivity

Common database operations become simple one-liners.

### Modular Architecture

Use the full stack or only individual components.

### Handles PocketBase Quirks

File management, expansions, and empty field cleanup are handled automatically.

---

# License

MIT licensed.

Contributions and PRs are welcome.
