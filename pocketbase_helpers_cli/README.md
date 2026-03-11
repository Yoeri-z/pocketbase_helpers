# pocketbase_helpers_cli

A command-line tool to automatically generate Dart model classes from a PocketBase `pb_schema.json` file. This CLI is designed to work seamlessly with the [`pocketbase_helpers`](https://pub.dev/packages/pocketbase_helpers) package.

## Installation

You can activate the CLI globally:

```bash
dart pub global activate pocketbase_helpers_cli
```

## Usage

Once activated, you can run the tool by default it assumes the pocketbase schema is in the working directory:

```bash
pb_generate --output lib/models/generated/pocketbase_models.dart
```

### Options

| Option     | Abbr | Default           | Description                                         |
| ---------- | ---- | ----------------- | --------------------------------------------------- |
| `--schema` | `-s` | `pb_schema.json`  | Path to the PocketBase schema JSON file.            |
| `--output` | `-o` | `lib/models.dart` | Path where the generated Dart file should be saved. |
| `--help`   | `-h` |                   | Show usage information.                             |

This cli tool uses string buffers to write the file, this means generation is lighting fast but the source code is a little hard on the eyes. Because pocketbase models are fairly flat I see this as acceptable.

## More docs

For more documentation see [`pocketbase_helpers`](https://pub.dev/packages/pocketbase_helpers).

## License

MIT
