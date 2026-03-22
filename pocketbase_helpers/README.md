# pocketbase_helpers

A powerful, type-safe Dart wrapper for **PocketBase**. Simplify your development with generated models, collection helpers, and built-in support for authentication, files, and realtime updates.

---

# Features

- **Type-Safety:** Strongly typed models generated from your schema.
- **Full api binding:** Generated fully typed api bindings for a large part of the pocketbase api
- **Realtime Ready:** Support for watching records and lists or records with a debounce.
- **Auth Simplified:** Concise helpers for authentication flows.
- **File Management:** Easy handling of (multi) file fields and URLs.
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

  // Query with type-safety
  final posts = await Posts.api().getFullList();

  for (final post in posts) {
    print(post.title);
  }

  // Authenticate
  await Users.auth().withPassword('user@example.com', 'password123');

  // Quickly check authentication status on auth collections
  if(User.isAuthenticated()){
    final user = User.getAuthenticated();

    var post = await Posts.api().create({
      'title' : 'Powering flutter apps with pocketbase!',
      'creator' : user.id,
    });

    /// File fields get their own generated api
    post = await Posts.thumbnailApi().set('cute_cat.png', imageBytes);
  }

  //Close connection when application is done
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
- [JSON field generation](#json-field-generation)
- [Utilities](#utilities)
- [Low-Level API](#low-level-api)
- [Modular Usage](#modular-usage)
- [Limitations](#limitations)
- [License](#license)

---

# Core Concepts

## Connection Management

`PocketBaseConnection` provides a singleton access to your PocketBase instance.

```dart
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  lang: 'en-US', // Optional
  authStore: myPersistentStore, // Optional
);

final pb = PocketBaseConnection.pb; // Access instance

// check server health
final healthResult = await PocketBaseConnection.health();

// close the connection
PocketBaseConnection.close();
```

### Connection Hooks

Modify data globally before it hits the database. Perfect for setting `created_by` or `updated_by` fields automatically.

```dart
PocketBaseConnection.setHooks(
  preCreationHook: (collection, pb, map) {
    if (User.isAuthenticated()) map['author_id'] = User.getAuthenticated().id;

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
  @override
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> map)
    => Category(id: map['id'], name: map['name']);

  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  //If you use json_serializable you can implement toMap like this
  @override
  Map<String, dynamic> toMap() => toJson();
}

// Create helpers manually
final categoriesApi = CollectionHelper<Category>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'categories',
  mapper: Category.fromJson,
);

// Helper for authentication
final userApi = AuthHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'users',
  mapper: User.fromJson
)

// Helper for file fields
final userApi = FileHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'users',
  id: user.id,
  field: 'avatar'
  mapper: User.fromJson
)

// Helper for powerful realtime operations
final realtimeApi = RealtimeHelper<User>(
  pocketBaseInstance: PocketBaseConnection.pb,
  collection: 'users',
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


//Get paginated list
final results = await Posts.api().getList(
  page: 1,
  perPage: 20,
  expr: 'status = {:status}',
  params: {'status': 'published'},
  sort: '-created',
);

// Get full list
final result = await Posts.api().getFullList(/*query arguments*/),

// Get the first matching argument or none
final result = await Posts.api().getOneOrNull(/*query arguments*/),

// Count the amount of matching records
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
// Get the realtime helper, it is strongly recommended to add a debounce duration.
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

// Upload/Update file
await avatar.set('profile.jpg', imageBytes);

// Remove file
await avatar.unset();

// Multi file fields have a slightly different api
final attachments = Posts.attachmentApi(postId);

// Add a singular file to the field
attachments.add('file.pdf', fileBytes)

// Add multiple files to the field at once
attachments.addMany({
  'file.pdf' : fileBytes,
  'image.png' : imageBytes,
});

// Remove file with a given name
attachments.remove('file.pdf');

// Remove many files with the given names
attachments.removeMany(['file.pdf', 'image.png']);

// Remove all files from the field
attachements.removeAll();

// You can get file URLs directly from the generated model
final url = user.getFileUrl(user.avatar);

// You can also use this helper method to construct file urls
HelperUtils.buildFileUrl(collection, recordId, fileName);
```

## Authentication

Simplified auth workflows via `.auth()`. All methods handle errors themselves and return a result object containing a `status` (`AuthStatus`) and optionally the auth token and the authenticated `record` (if `AuthStatus` was `.ok`). This means that methods from the auth api do not have to be wrapped in try-catch blocks.

```dart
// Email/Password Login
final result = await Users.auth().withPassword('user@example.com', 'password123');

if (result.status == AuthStatus.ok) {
  print('Authenticated: ${result.record!.name}');
} else if (result.status == AuthStatus.incorrectCredentials) {
  print('Invalid email or password');
}

// OAuth2 Login (Google, GitHub, etc.)
await Users.auth().withOAuth2('google', urlCallback: (url) async {
  await launchUrl(url);
});

// One-Time Password (OTP)
// Request OTP
final request = await Users.auth().requestOTP('user@example.com');
if (request.status == AuthStatus.ok) {
  // Submit code
  final auth = await Users.auth().withOTP(request.otpId!, '123456');
}

// Verification & Password Resets
await Users.auth().requestVerification('user@example.com');
await Users.auth().confirmVerification('TOKEN');

await Users.auth().requestPasswordReset('user@example.com');
await Users.auth().confirmPasswordReset('TOKEN', 'newPassword', 'newPassword');

// Auth refresh
await Users.auth().refresh();
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

# json field generation

If your PocketBase schema includes **JSON fields**, you can tell the generator to automatically create `fromJson` and `toJson` methods.

Because these JSON fields often point to other custom classes in your project, the generator uses a **"Part-File"** setup. This allows the generated code to "borrow" all the imports from a file you control.

### 1. Run the Generator

Add the `--with-from-json` flag to your command.

```bash
pb_generate.dart -o "./lib/models/generated.dart" --with-from-json
```

### 2. Create your "spec" File

Create a new file named `serializables_spec.dart` in the same folder as your generated file. This file will manage all the imports for the generated file.

**File Structure:**

```text
lib/
└── models/
    ├── serializables_spec.dart <-- You create this
    └── generated.dart   <-- The CLI creates this
```

### 3. Connect the Files

Inside your `serializables_spec.dart` file, you need to do two things:

1. **Import** everything your models need.
2. **Link** to the generated file using the `part` keyword.

In the end your `serializables_spec.dart` should look something like this:

```dart
// lib/models/serializables_spec.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:my_app/models/my_custom_class.dart'; // Your custom types

// This links the two files together
part 'generated.dart';
```

---

# Utilities

`HelperUtils` provides common logic for querying, data transformation, and file handling.

### Querying & Sorting

```dart
// Build advanced search queries across multiple fields
final (expr, params) = HelperUtils.buildQuery(
  ['apple', 'phone'],           // keywords
  ['name', 'description'],      // searchable fields
  otherFilters: ['active = true'],
);

// Build sort strings (+field or -field)
final sort = HelperUtils.buildSortString(sortField: 'created', ascending: false); // "-created"
```

### Data Transformation

```dart
// Clean maps (removes empty strings, making them null for Dart compatibility)
final clean = HelperUtils.cleanMap(rawData);

// Merge expansions (moves 'expand' fields into the main map with custom keys)
final merged = HelperUtils.mergeExpansions({'user_id': 'author'}, recordMap);

// Get record JSON (combined clean + merge expansions)
final json = HelperUtils.getRecordJson(recordModel, {'user_id': 'author'});
```

### File & URL Helpers

```dart
// Build a direct file URL
final uri = HelperUtils.buildFileUrl('users', userId, 'avatar.jpg');

// Extract filenames from URLs
final name = HelperUtils.getNameFromUrl('https://.../file.png');
final names = HelperUtils.getNamesFromUrls(['url1', 'url2']);

// IO Only: Convert file paths to Uint8List map for uploads
// This method will throw when used on web platforms
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

# Limitations

As of now this package does provide support for any of the apis related to:

- superusers
- batching
- settings
- backups
- crons

The batching api will probably be added somewhere in the future, the other apis do not require type casting or are rarely used.
You can ofcourse still access these apis from the base pocketbase instance:

```dart
PocketBaseConnection.pb;
```

# License

MIT Licensed.
