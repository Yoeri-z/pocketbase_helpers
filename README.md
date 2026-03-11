# PocketBase Helpers

A set of Dart/Flutter utilities and code generation tools to make working with [PocketBase](https://pocketbase.io) easier, type-safe, and more productive.

## Packages

| Package | Description | Version |
| --- | --- | --- |
| [**pocketbase_helpers**](./pocketbase_helpers) | Core library for typed records, collection helpers, and advanced searching. | `0.5.0` |
| [**pocketbase_helpers_cli**](./pocketbase_helpers_cli) | Code generator to automatically create Dart models from `pb_schema.json`. | `1.0.0` |

## Modular Design

Every component of this package is usable standalone:
- **Core Components**: `CollectionHelper` and `BaseHelper` work independently
- **Connection Manager**: Optional `PocketBaseConnection` for connection management
- **CLI Tool**: Optional code generation for type-safe models
- **Standalone Usage**: You can opt out of any component and use only what you need

## Quick Start

### 1. Define your Schema
Export your PocketBase schema to a `pb_schema.json` file (via the PocketBase Admin UI or API).

### 2. Generate Models
Use the CLI to generate strongly-typed model classes for all your collections:

```bash
# Activate locally (if not yet published)
dart pub global activate pocketbase_helpers_cli

# Run generation
pb_generate -s pb_schema.json -o lib/models.dart
```

### 3. Open a Connection
Use the new `PocketBaseConnection.open()` API to manage your connections:

```dart
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

void main() {
  // Open a connection to your PocketBase instance
  PocketBaseConnection.open(
    'http://127.0.0.1:8090',
    lang: 'en-US',
    preCreationHook: (collection, pb, map) {
      // Automatically set creator_id for all records
      if (pb.authStore.isValid) {
        map['creator_id'] = pb.authStore.record?.id;
      }
      return map;
    },
  );
  
  // Your app code here...
  
  // Close the connection when done
  PocketBaseConnection.close();
}
```

### 4. Use with Generated Models
Enjoy strong typing, deep equality, and simplified CRUD operations with one-liner queries:

```dart
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'models.dart';

void main() async {
  // Open connection
  PocketBaseConnection.open('http://127.0.0.1:8090');
  
  // One-liner: Fetch all users
  final users = await Users.api().getFullList();
  
  // One-liner: Create a new user
  final newUser = await Users.api().create(data: {
    'email': 'user@example.com',
    'password': 'securepassword',
    'passwordConfirm': 'securepassword',
  });
  
  // One-liner: Update a user
  final updated = await Users.api().update(newUser.copyWith(name: 'John Doe'));
  
  // One-liner: Search users
  final searchResults = await Users.api().search(
    keywords: ['john', 'doe'],
    searchableFields: ['name', 'email'],
  );
  
  print('Found ${users.length} users');
  print('Created user: ${newUser.email}');
  print('Updated user: ${updated.name}');
  print('Search results: ${searchResults.items.length}');
  
  // Close connection
  PocketBaseConnection.close();
}
```

## Powerful One-Liner Examples

See the power of the API with these concise examples:

```dart
// Fetch all users with a single line
final users = await Users.api().getFullList();

// Get a single user by ID
final user = await Users.api().getOne('user_id_123');

// Create a record
final post = await Posts.api().create(data: {'title': 'Hello World'});

// Update a record
final updated = await Posts.api().update(post.copyWith(title: 'Updated!'));

// Delete a record
await Posts.api().delete('record_id');

// Advanced search across multiple fields
final results = await Products.api().search(
  keywords: ['phone', 'apple'],
  searchableFields: ['name', 'description', 'category'],
);

// Count records
final count = await Orders.api().count();

// Get paginated list with filters
final page = await Users.api().getList(
  page: 1,
  perPage: 20,
  sort: '-created',
  expr: 'verified = {:verified}',
  params: {'verified': true},
);
```

## Connection Management

### Opening Connections
```dart
// Basic connection
PocketBaseConnection.open('http://127.0.0.1:8090');

// With custom language and auth store
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  lang: 'nl-NL',
  authStore: myAuthStore,
);

// With hooks for automatic field population
PocketBaseConnection.open(
  'http://127.0.0.1:8090',
  preCreationHook: (collection, pb, map) {
    if (pb.authStore.isValid) {
      map['created_by'] = pb.authStore.record?.id;
      map['created_at'] = DateTime.now().toIso8601String();
    }
    return map;
  },
  preUpdateHook: (collection, pb, map) {
    map['updated_at'] = DateTime.now().toIso8601String();
    return map;
  },
);
```

### Closing Connections
```dart
// Close the current connection
PocketBaseConnection.close();

// Connections are automatically managed
// You can open multiple connections sequentially
PocketBaseConnection.open('http://server1:8090');
// Work with server1...
PocketBaseConnection.close();

PocketBaseConnection.open('http://server2:8090');
// Work with server2...
PocketBaseConnection.close();
```

## CLI Usage

The CLI tool generates complete, type-safe Dart models from your PocketBase schema:

```bash
# Basic usage
pb_generate -s pb_schema.json -o lib/models.dart

# With custom output path
pb_generate -s path/to/schema.json -o lib/generated/models.dart

# Using default schema file (pb_schema.json in current directory)
pb_generate -o lib/models.dart
```

## Standalone Usage

Every component works independently:

### Use only CollectionHelper (no connection manager)
```dart
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

final pb = PocketBase('http://127.0.0.1:8090');
final helper = CollectionHelper(
  pocketBaseInstance: pb,
  collection: 'users',
  mapper: User.fromMap,
);

final users = await helper.getFullList();
```

### Use only BaseHelper (most flexible)
```dart
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

final pb = PocketBase('http://127.0.0.1:8090');
final helper = BaseHelper(pocketBaseInstance: pb);

final users = await helper.getFullList(
  'users',
  mapper: User.fromMap,
);
```

### Use only the CLI (generate models without runtime library)
```bash
# Generate models and use them with plain pocketbase package
pb_generate -s schema.json -o models.dart
```

## Features

- **Type Safety**: No more `Map<String, dynamic>` everywhere.
- **Deep Equality**: Generated models support `==` and `hashCode` (including lists).
- **Search Utilities**: Built-in support for advanced keyword searching across multiple fields.
- **File & Relation Helpers**: Simplified management of PocketBase file and relation fields.
- **Hooks**: Register pre-creation and pre-update hooks at global or helper level.
- **Connection Management**: Simple API for opening and closing connections.
- **Modular Design**: Use only what you need - every component works standalone.
- **One-Liner Operations**: Concise API for common operations.

## License

MIT
