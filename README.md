# PocketBase Helpers

A set of Dart/Flutter utilities and code generation tools to make working with [PocketBase](https://pocketbase.io) easier, type-safe, and more productive.

## Packages

| Package | Description | Version |
| --- | --- | --- |
| [**pocketbase_helpers**](./pocketbase_helpers) | Core library for typed records, collection helpers, and advanced searching. | `0.5.0` |
| [**pocketbase_helpers_cli**](./pocketbase_helpers_cli) | Code generator to automatically create Dart models from `pb_schema.json`. | `1.0.0` |

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

### 3. Use with PocketBase
Enjoy strong typing, deep equality, and simplified CRUD operations:

```dart
import 'package:pocketbase/pocketbase.dart';
import 'models.dart';

final pb = PocketBase('http://127.0.0.1:8090');

void main() async {
  // Use the generated static helper
  final posts = await Posts.helper(pb).getFullList();

  for (final post in posts) {
    print('${post.title} created at ${post.created}');
    
    // Use copyWith for easy updates
    final updated = post.copyWith(title: 'New Title');
    await Posts.helper(pb).update(updated);
  }
}
```

## Features

- **Type Safety**: No more `Map<String, dynamic>` everywhere.
- **Deep Equality**: Generated models support `==` and `hashCode` (including lists).
- **Search Utilities**: Built-in support for advanced keyword searching across multiple fields.
- **File & Relation Helpers**: Simplified management of PocketBase file and relation fields.
- **Hooks**: Register pre-creation and pre-update hooks at the helper level.

## License

MIT
