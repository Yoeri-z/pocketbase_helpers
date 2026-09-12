# pocketbase_helpers_cli

A command-line tool to automatically generate Dart model classes from a PocketBase schema. The schema can be read from a local `pb_schema.json` file or fetched directly from a PocketBase API running on your local machine. This CLI is designed to work seamlessly with the [`pocketbase_helpers`](https://pub.dev/packages/pocketbase_helpers) package.

## Installation

You can activate the CLI globally:

```bash
dart pub global activate pocketbase_helpers_cli
```

## Usage

Generate type-safe Dart models from your PocketBase schema:

```bash
# From a local schema file
pb_generate -o lib/models.dart

# Specify schema file and output path
pb_generate -s pb_schema.json -o lib/generated/models.dart

# From a PocketBase API running on localhost (superuser login)
pb_generate -p 8090 -e admin@example.com -w hunter2 -o lib/models.dart

# Generate to standard location for Flutter projects
pb_generate -o lib/models/generated.dart
```

### How the source is picked

There are two starting points that end in the same result:

1. **API mode** — if `--port`, `--email` or `--password` is set (all three are required), the CLI logs in as a superuser and fetches the collection definitions from the PocketBase API on `http://localhost:<port>`.
2. **File mode** — otherwise the CLI reads the schema from `--source` (falling back to `pb_schema.json` in the working directory).

### Config file

Any flags not provided on the command line are filled in from a `pb_generate.yaml` file in the working directory:

```yaml
source: pb_schema.json

# ... or, to fetch from the API on localhost instead:
port: 8090
email: admin@example.com
password: hunter2

output: lib/models.dart
```

### Safety: localhost only

In API mode the CLI only ever connects to `http://localhost:<port>`. For safety reasons there is deliberately **no way** to configure a hostname or full URL — not via the command line, not via the config file.

### Options

| Option             | Abbr | Default           | Description                                                                  |
| ------------------ | ---- | ----------------- | ---------------------------------------------------------------------------- |
| `--source`         | `-s` | `pb_schema.json`  | Path to the PocketBase schema JSON file.                                     |
| `--output`         | `-o` | `lib/models.dart` | Path where the generated Dart file should be saved.                          |
| `--port`           | `-p` |                   | Port of the PocketBase API running on localhost.                             |
| `--email`          | `-e` |                   | PocketBase superuser email.                                                  |
| `--password`       | `-w` |                   | PocketBase superuser password.                                               |
| `--with-from-json` |      |                   | Assumes that json fields have serializable models with the same name and adds a .toJson and .fromJson call. |
| `--with-from-map`  |      |                   | Same as `--with-from-json` but with .toMap and .fromMap instead.             |
| `--help`           | `-h` |                   | Show usage information.                                                      |

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
