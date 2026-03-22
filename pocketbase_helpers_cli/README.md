# pocketbase_helpers_cli

A command-line tool to automatically generate Dart model classes from a PocketBase `pb_schema.json` file. This CLI is designed to work seamlessly with the [`pocketbase_helpers`](https://pub.dev/packages/pocketbase_helpers) package.

## Installation

You can activate the CLI globally:

```bash
dart pub global activate pocketbase_helpers_cli
```

## Usage

Generate type-safe Dart models from your PocketBase schema:

```bash
# Basic usage with default schema file
pb_generate -o lib/models.dart

# Specify schema file and output path
pb_generate -s pb_schema.json -o lib/generated/models.dart

# Generate to standard location for Flutter projects
pb_generate -o lib/models/generated.dart
```

### Options

| Option             | Abbr | Default           | Description                                                                                                 |
| ------------------ | ---- | ----------------- | ----------------------------------------------------------------------------------------------------------- |
| `--schema`         | `-s` | `pb_schema.json`  | Path to the PocketBase schema JSON file.                                                                    |
| `--output`         | `-o` | `lib/models.dart` | Path where the generated Dart file should be saved.                                                         |
| `--with-from-json` |      |                   | Assumes that json fields have serializable models with the same name and adds a .toJson and .fromJson call. |
| `--with-from-map`  |      |                   | Same as `--with-from-json` but with .toMp and .fromMap instead.                                             |
| `--help`           | `-h` |                   | Show usage information.                                                                                     |

## Generated Code Example

The CLI generates complete, type-safe models:

```dart
// Model class for each collection
class User implements PocketBaseRecord {
  @override
  final String id;
  final String email;
  final String name;
  final DateTime created;
  final DateTime updated;

  // Constructor, fromMap, toMap, copyWith, ==, hashCode
}

// Helper class with static api() method
abstract final class Users {
  static const String collectionName = 'users';

  static CollectionHelper<User> api([PocketBase? pocketbaseInstance]) =>
      CollectionHelper(
        pocketBaseInstance: pocketbaseInstance,
        collection: 'users',
        mapper: User.fromMap,
      );
  // more helpers like realtime(), auth(), avatarApi(), ...
}
```

---

For more documentation see [pocketbase_helpers](https://pub.dev/packages/pocketbase_helpers)

## LICENSE

MIT
