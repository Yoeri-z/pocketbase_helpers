# pocketbase_helpers

A powerful, type-safe Dart wrapper for **PocketBase**. Simplify your development with generated models, collection helpers, and built-in support for authentication, files, and realtime updates.

---

# Features

- **Type-Safety:** Strongly typed models generated from your schema.
- **Realtime Ready:** First-class support for watching records and lists.
- **Auth Simplified:** Concise helpers for authentication flows.
- **File Management:** Easy handling of multi-file fields and URLs.
- **Extensible:** Lifecycle hooks for pre-creation and pre-update modifications.
- **Modular:** Use the full stack or just the parts you need.

---

# Quick Start

## 1. Installation

```bash
dart pub add pocketbase pocketbase_helpers
```

## 2. Generate Models (Recommended)

Generate Dart models directly from your PocketBase schema to get full type-safety.

Install the CLI:

```bash
dart pub global activate pocketbase_helpers_cli
```

Export your schema from PocketBase (`pb_schema.json`) and run:

```bash
pb_generate -s pb_schema.json -o lib/models.dart
```

## 3. Basic Usage

```dart
import 'models.dart';

void main() async {
  // Initialize global connection
  PocketBaseConnection.open('http://127.0.0.1:8090');

  // Authenticate
  await Users.auth().withPassword('user@example.com', 'password123');

  // Quickly check authentication status on auth collections
  if(User.isAuthenticated()){
    // Query with type-safety
    final posts = await Posts.api().getFullList();

    for (final post in posts) {
      print(post.title);
    }
  }

  // 4. Close when done
  PocketBaseConnection.close();
}
```

---

# Index

- [Features](#features)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
  - [Connection Management](#connection-management)
  - [Models & Helpers](#models-&-helpers)
- [Quick API Reference](#quick-api-reference)
  - [Querying Data](#querying-data)
  - [Realtime Updates](#realtime-updates)
  - [File Handling](#file-handling)
  - [Authentication](#authentication)
  - [Relation Expansions](#relation-expansions)
- [Utilities](#utilities)
- [Low-Level API](#low-level-api)
- [Modular Usage](#modular-usage)
- [License](#license)

---

# Core Concepts

## Connection Management

`PocketBaseConnection` provides a singleton access to your PocketBase instance.

```dart
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  lang: 'en-US',
  authStore: myPersistentStore, // Optional
);

final pb = PocketBaseConnection.pb; // Access raw instance

// close the connection

PocketBaseConnection.close();
```

### Connection Hooks

Modify data globally before it hits the database. Perfect for setting `created_by` or `updated_by` fields automatically.

```dart
PocketBaseConnection.setHooks(
  preCreationHook: (collection, pb, map) {
    if (pb.authStore.isValid) map['author'] = pb.authStore.record?.id;
    return map;
  },
);
```

### Using your own PocketBase instance

If you want to use your own **PocketBase** instance you can supply it with any api call

```dart
final pb = PocketBase('https://api.mydomain.com');

// a unique pocketbase instance can be passed to all apis.
final posts = await Posts.api(pb).getList();
```

## Models & Helpers

The generator creates two primary components for every collection:

| Component          | Purpose                                               | Example          |
| :----------------- | :---------------------------------------------------- | :--------------- |
| **Entity Model**   | Represents a single record with typed fields.         | `User`, `Post`   |
| **Collection API** | A static class providing helpers for that collection. | `Users`, `Posts` |

### Manual Models (Non-Generated)

You can also use helpers without the generator by implementing `PocketBaseRecord`:

```dart
class Category implements PocketBaseRecord {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> map) => Category(id: map['id'], name: map['name']);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Create helpers manually
final categoriesApi = CollectionHelper<Category>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  mapper: Category.fromJson,
);

// helper for authentication
final userApi = AuthHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  mapper: User.fromJson
)

// helper for file fields
final userApi = FileHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  id: user.id,
  field: 'avatar'
  mapper: User.fromJson
)

// helper for powerful realtime operations
final realtimeApi = RealtimeHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  mapper: User.fromJson,
)
```

---

# Quick API Reference

## Querying Data

Access your collection via `.api()`.

```dart
// Basic CRUD
final user = await Users.api().getOne('RECORD_ID');
final newUser = await Users.api().create(data: {'name': 'Jane'});
await Users.api().update(user.copyWith(name: 'Jane Doe'));
await Users.api().delete(user.id);


//get paginated list
final results = await Posts.api().getList(
  page: 1,
  perPage: 20,
  expr: 'status = {:status}',
  params: {'status': 'published'},
  sort: '-created',
);

// get full list
final result = await Posts.api().getFullList(/*query arguments*/),

// get the first matching argument or none
final result = await Posts.api().getOneOrNull(/*query arguments*/),

// count the amount of matching records
final result = await Posts.api().count(/*query arguments*/),

// Search query
// this is a special query to keyword search across fields in pocketbase
final result = await Posts.api().search(
  keywords: ['apple', 'ipad']
  searchableFields: ['product_name', 'product_description']
  /* regular query arguments */
)
```

## Realtime Updates

The `.realtime()` helper provides reactive streams.

```dart
// get the realtime helper, it is strongly recommended to add a debounce duration.
final api = Posts.realtime(debounce: Duration(milliseconds: 500));

// Watch a specific record.
api.watchOne(id: 'post_id').listen((user) => print(user?.name));

// Watch a list (re-fetches on any change in the collection)
Posts.realtime().watchList(/* query arguments */).listen((list) {
  print('List updated: ${list.items.length} items');
});

// Watch a full list
Posts.realtime().watchFullList(/* query arguments */).listen((list) {
  print('List updated: ${list.items.length} items');
});

// Watch the first record from the given query, or none if there is no match.
Posts.realtime().watchOneOrNull(/* query arguments */).listen((list) {
  print('Updated');
});
```

## File Handling

Manage files using field-specific helpers.

```dart
final avatar = Users.avatarApi(userId);

// Upload/Update
await avatar.set('profile.jpg', imageBytes);

// Delete
await avatar.unset();

// multi file fields have a slightly different api
final attachments = Posts.attachmentApi(postId);

// add a singular file to the field
attachments.add('file.pdf', fileBytes)

// add multiple files to the field at once
attachments.addMany({
  'file.pdf' : fileBytes,
  'image.png' : imageBytes,
});

// remove file with a given name
attachments.remove('file.pdf');

// remove many files with the given names
attachments.removeMany(['file.pdf', 'image.png']);

// remove all files from the field
attachements.removeAll();

// You can get file URLs directly from the generated model
final url = user.getFileUrl(user.avatar);

// you can also use this helper method to construct file urls
HelperUtils.buildFileUrl(collection, recordId, fileName);
```

## Authentication

Simplified auth workflows via `.auth()`. All methods return a result object containing a `status` (`AuthStatus`) and the authenticated `record` (if applicable).

```dart
// 1. Email/Password Login
final result = await Users.auth().withPassword('user@example.com', 'password123');

if (result.status == AuthStatus.ok) {
  print('Authenticated: ${result.record!.name}');
} else if (result.status == AuthStatus.incorrectCredentials) {
  print('Invalid email or password');
}

// 2. OAuth2 Login (Google, GitHub, etc.)
await Users.auth().withOAuth2('google', urlCallback: (url) async {
  await launchUrl(url);
});

// 3. One-Time Password (OTP)
// Request OTP
final request = await Users.auth().requestOTP('user@example.com');
if (request.status == AuthStatus.ok) {
  // Submit code
  final auth = await Users.auth().withOTP(request.otpId!, '123456');
}

// 4. Verification & Password Resets
await Users.auth().requestVerification('user@example.com');
await Users.auth().confirmVerification('TOKEN');

await Users.auth().requestPasswordReset('user@example.com');
await Users.auth().confirmPasswordReset('TOKEN', 'newPassword', 'newPassword');
```

## Relation Expansions

Relations are automatically mapped if configured in the helper, the remaps only work with custom models.

```dart
final postApi = CollectionHelper<Post>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  mapper: Post.fromJson,
  expands: {
    'user_id' : 'user'
  }
);

final post = postApi.getOne(post.id);

print('Post by ${post.user.name}');
```

---

# Utilities

`HelperUtils` provides common logic for querying, data transformation, and file handling.

### Querying & Sorting

```dart
// 1. Build advanced search queries across multiple fields
final (expr, params) = HelperUtils.buildQuery(
  ['apple', 'phone'],           // keywords
  ['name', 'description'],      // searchable fields
  otherFilters: ['active = true'],
);

// 2. Build sort strings (+field or -field)
final sort = HelperUtils.buildSortString(sortField: 'created', ascending: false); // "-created"
```

### Data Transformation

```dart
// 1. Clean maps (removes empty strings, making them null for Dart compatibility)
final clean = HelperUtils.cleanMap(rawData);

// 2. Merge expansions (moves 'expand' fields into the main map with custom keys)
final merged = HelperUtils.mergeExpansions({'user_id': 'author'}, recordMap);

// 3. Get record JSON (combined clean + merge expansions)
final json = HelperUtils.getRecordJson(recordModel, {'user_id': 'author'});
```

### File & URL Helpers

```dart
// 1. Build a direct file URL
final uri = HelperUtils.buildFileUrl('users', userId, 'avatar.jpg');

// 2. Extract filenames from URLs
final name = HelperUtils.getNameFromUrl('https://.../file.png');
final names = HelperUtils.getNamesFromUrls(['url1', 'url2']);

// 3. IO Only: Convert file paths to Uint8List map for uploads
// Note: Throws on Web.
final files = HelperUtils.pathsToFiles(['/path/to/image.jpg']);
```

---

# Low-Level API

`BaseHelper` provides the same power as `CollectionHelper` but requires you to pass the collection name and mapper for every call. This is useful for dynamic collections or when you don't want to define a full `PocketBaseRecord`.

```dart
final helper = BaseHelper();

final users = await helper.getFullList(
  'users',
  mapper: (map) => User.fromMap(map),
);
```

# Modular Usage

The package is designed to be modular. You can use only what you need:

- **Full Stack:** `PocketBaseConnection` + Generated Models.
- **No generator:** Use custom helpers with the connection manager or with a custom pocketbase instance.
- **Utilities Only:** Use `HelperUtils` and `BaseHelper` as a light wrapper to make pocketbase requests strongly typed.

---

# License

MIT Licensed.
