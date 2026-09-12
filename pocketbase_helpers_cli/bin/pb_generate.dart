import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';

final parser = ArgParser()
  ..addOption('source', abbr: 's', help: 'Path to the pb_schema.json file.')
  ..addOption(
    'output',
    abbr: 'o',
    help: 'Path where the models.dart file should be generated.',
  )
  ..addOption(
    'port',
    abbr: 'p',
    help: 'Port of the PocketBase API running on localhost.',
  )
  ..addOption('email', abbr: 'e', help: 'PocketBase superuser email.')
  ..addOption('password', abbr: 'w', help: 'PocketBase superuser password.')
  ..addFlag(
    'with-from-json',
    negatable: false,
    help:
        'Automatically infer the json-serializable type from the fields name and call fromJson on it for parsing',
  )
  ..addFlag(
    'with-from-map',
    negatable: false,
    help:
        'Automatically infer the json-serializable type from the fields name and call fromMap on it for parsing'
        'This option integrates well with dart_mappable',
  )
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

Future<void> main(List<String> arguments) async {
  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print(e);
    _showHelp(parser);
    exit(1);
  }

  if (argResults['help'] == true) {
    _showHelp(parser);
    return;
  }

  // The pb_generate.yaml config file fills in any missing flags.
  final config = readConfig('.');

  final source = _string(argResults['source'] ?? config['source']);
  final output =
      _string(argResults['output'] ?? config['output']) ?? 'lib/models.dart';
  final port = _int(argResults['port'] ?? config['port']);
  final email = _string(argResults['email'] ?? config['email']);
  final password = _string(argResults['password'] ?? config['password']);

  final withFromJson = argResults['with-from-json'] as bool;
  final withFromMap = argResults['with-from-map'] as bool;

  if (withFromJson && withFromMap) {
    print(
      'Error: with-from-json and with-from-map flags cant both be active at the same time',
    );
    exit(1);
  }

  String? partOfPath;
  if (withFromJson || withFromMap) {
    partOfPath = _getPartOfPath(output);
  }

  List<dynamic> schema;
  try {
    if (port != null || email != null || password != null) {
      if (port == null || email == null || password == null) {
        print(
          'Error: --port, --email and --password must all be set to fetch '
          'the schema from the PocketBase API.',
        );
        exit(1);
      }
      schema = await fetchCollections(
        port: port,
        email: email,
        password: password,
      );
    } else {
      schema = _parseSchema(source ?? 'pb_schema.json');
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }

  final generator = ModelGenerator(
    schema: schema,
    jsonMapBehavior: withFromMap
        ? JsonMapBehavior.fromMap
        : withFromJson
        ? JsonMapBehavior.fromJson
        : JsonMapBehavior.none,
    partOfPath: partOfPath,
  );

  print('Generating models...');
  var output_ = generator.generate();

  var outputFile = File(output);
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(output_);

  if (partOfPath != null) {
    outputFile = File(path.join(path.dirname(output), partOfPath));
    if (!outputFile.existsSync()) {
      output_ =
          '// This library provides imports for $partOfPath\n'
          'import "package:pocketbase/pocketbase.dart";\n'
          'import "package:pocketbase_helpers/pocketbase_helpers.dart";\n'
          '\n'
          'part "${path.basename(output)}";';

      outputFile.createSync(recursive: true);
      outputFile.writeAsStringSync(output_);
    }
  }
  print('Successfully generated models to $output');
}

String? _string(Object? value) => value?.toString();

int? _int(Object? value) =>
    value == null ? null : int.tryParse(value.toString());

String? _getPartOfPath(String outputPath) {
  final fileName = path.basename(outputPath);
  final parts = fileName.split('.');
  if (parts.length < 3) {
    print(
      'Error: When using --with-from-json or --with-from-map, the output file name must be of format file_name.something.dart (e.g. models.g.dart)',
    );
    exit(1);
  }
  return '${parts.first}.dart';
}

List<dynamic> _parseSchema(String schemaPath) {
  final schemaFile = File(schemaPath);

  if (!schemaFile.existsSync()) {
    print('Error: Schema file not found at $schemaPath');
    exit(1);
  }

  return jsonDecode(schemaFile.readAsStringSync()) as List<dynamic>;
}

void _showHelp(ArgParser parser) {
  print('Usage: pb_generate [options]');
  print(parser.usage);
}
