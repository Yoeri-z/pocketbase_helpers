import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';

final parser = ArgParser()
  ..addOption(
    'schema',
    abbr: 's',
    help: 'Path to the pb_schema.json file.',
    defaultsTo: 'pb_schema.json',
  )
  ..addOption(
    'output',
    abbr: 'o',
    help: 'Path where the models.dart file should be generated.',
    defaultsTo: 'lib/models.dart',
  )
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

void main(List<String> arguments) {
  ArgResults argResults = _parseArgs(arguments);

  if (argResults['help'] == true) {
    _showHelp(parser);
    return;
  }

  final schemaPath = argResults['schema'] as String;
  final outputPath = argResults['output'] as String;

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
    partOfPath = _getPartOfPath(outputPath);
  }

  final List<dynamic> schema = _parseSchema(schemaPath);

  final generator = ModelGenerator(
    schema: schema,
    jsonMapBehavior: withFromMap
        ? JsonMapBehavior.fromMap
        : withFromJson
        ? JsonMapBehavior.fromJson
        : JsonMapBehavior.none,
    partOfPath: partOfPath,
  );

  print('Generating models from $schemaPath...');
  var output = generator.generate();

  var outputFile = File(outputPath);
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(output);

  if (partOfPath != null) {
    outputFile = File(path.join(path.dirname(outputPath), partOfPath));
    if (!outputFile.existsSync()) {
      output =
          '// This library provides imports for $partOfPath\n'
          'import "package:pocketbase/pocketbase.dart";\n'
          'import "package:pocketbase_helpers/pocketbase_helpers.dart";\n'
          '\n'
          'part "${path.basename(outputPath)}";';

      outputFile.createSync(recursive: true);
      outputFile.writeAsStringSync(output);
    }
  }
  print('Successfully generated models to $outputPath');
}

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

  List<dynamic> schema;
  try {
    schema = jsonDecode(schemaFile.readAsStringSync()) as List<dynamic>;
  } catch (e) {
    print('Error: Failed to parse schema JSON: $e');
    exit(1);
  }
  return schema;
}

ArgResults _parseArgs(List<String> arguments) {
  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print(e);
    _showHelp(parser);
    exit(1);
  }

  return argResults;
}

void _showHelp(ArgParser parser) {
  print('Usage: pb_generate [options]');
  print(parser.usage);
}
