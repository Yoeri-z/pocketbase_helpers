/// Generator for PocketBase models from a pb_schema.json file.
class ModelGenerator {
  final List<dynamic> schema;

  final String outputFilePath;

  ModelGenerator({required this.schema, required this.outputFilePath});

  String generate() {
    final buffer = StringBuffer();

    _writeHeader(buffer);

    _writeImports(buffer);

    for (final collection in schema) {
      _writeClass(buffer, collection);
    }

    _writeFooter(buffer);

    return buffer.toString();
  }

  void _writeHeader(StringBuffer buffer) {
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");

    buffer.writeln();
  }

  void _writeImports(StringBuffer buffer) {
    buffer.writeln("import 'package:pocketbase/pocketbase.dart';");

    buffer.writeln(
      "import 'package:pocketbase_helpers/pocketbase_helpers.dart';",
    );

    buffer.writeln();
  }

  void _writeClass(StringBuffer buffer, Map<String, dynamic> collection) {
    final name = collection['name'] as String;

    final fields = collection['fields'] as List<dynamic>;

    final singularName = _singularize(name);

    final pluralName = _pluralize(name);

    final className = _toClassName(singularName);

    final helperClassName = _toClassName(pluralName);

    buffer.writeln("/// Model for the $name collection.");

    buffer.writeln("class $className implements PocketBaseRecord {");

    _writeFields(buffer, fields);

    _writeConstructor(buffer, className, fields);

    _writeFromMap(buffer, className, fields);

    _writeToMap(buffer, fields);

    _writeCopyWith(buffer, className, fields);

    _writeEquality(buffer, className, fields);

    _writeHashCode(buffer, fields);

    buffer.writeln("}");

    buffer.writeln();

    if (className != helperClassName) {
      buffer.writeln("/// Helper for the $name collection.");

      buffer.writeln("abstract final class $helperClassName {");

      _writeStaticHelper(buffer, className, name);

      buffer.writeln("}");

      buffer.writeln();
    } else {
      // If names are same (couldn't singularize), put helper inside class but renamed

      // Or just keep it as 'helper' inside the class.

      // Given the request "stay in under the plural form, so Users",

      // if they are same, we just put it inside the class as 'helper'.

      buffer.writeln("extension ${className}Helper on $className {");

      _writeStaticHelper(buffer, className, name);

      buffer.writeln("}");

      buffer.writeln();
    }
  }

  void _writeFields(StringBuffer buffer, List<dynamic> fields) {
    for (final field in fields) {
      final fieldName = field['name'] as String;

      final dartType = _toDartType(field);

      if (fieldName == 'id') {
        buffer.writeln("  @override");
      }

      buffer.writeln("  final $dartType $fieldName;");
    }

    buffer.writeln();
  }

  void _writeConstructor(
    StringBuffer buffer,

    String className,

    List<dynamic> fields,
  ) {
    buffer.writeln("  $className({");

    for (final field in fields) {
      final fieldName = field['name'] as String;

      final required = field['required'] == true || field['system'] == true;

      if (required) {
        buffer.writeln("    required this.$fieldName,");
      } else {
        buffer.writeln("    this.$fieldName,");
      }
    }

    buffer.writeln("  });");

    buffer.writeln();
  }

  void _writeFromMap(
    StringBuffer buffer,

    String className,

    List<dynamic> fields,
  ) {
    buffer.writeln("  static $className fromMap(Map<String, dynamic> map) {");

    buffer.writeln("    return $className(");

    for (final field in fields) {
      final fieldName = field['name'] as String;

      final typeStr = field['type'] as String;

      final dartType = _toDartType(field);

      final isNullable = dartType.endsWith('?');

      String mapping;

      if (typeStr == 'autodate' || typeStr == 'date') {
        if (isNullable) {
          mapping =
              "map['$fieldName'] != null ? DateTime.parse(map['$fieldName'] as String) : null";
        } else {
          mapping = "DateTime.parse(map['$fieldName'] as String)";
        }
      } else if (typeStr == 'number') {
        if (isNullable) {
          mapping =
              "map['$fieldName'] != null ? (map['$fieldName'] as num).toDouble() : null";
        } else {
          mapping = "(map['$fieldName'] as num).toDouble()";
        }
      } else if (typeStr == 'bool') {
        mapping = "map['$fieldName'] as bool";
      } else if (typeStr == 'json') {
        mapping = "map['$fieldName']";
      } else if (typeStr == 'relation' ||
          typeStr == 'file' ||
          typeStr == 'select') {
        final maxSelect = field['maxSelect'] ?? 1;

        if (maxSelect == 1) {
          mapping = "map['$fieldName'] as String${isNullable ? '?' : ''}";
        } else {
          mapping =
              "(map['$fieldName'] as List<dynamic>).map((e) => e as String).toList()";
        }
      } else {
        mapping = "map['$fieldName'] as String${isNullable ? '?' : ''}";
      }

      buffer.writeln("      $fieldName: $mapping,");
    }

    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln();
  }

  void _writeToMap(StringBuffer buffer, List<dynamic> fields) {
    buffer.writeln("  @override");
    buffer.writeln("  Map<String, dynamic> toMap() => {");

    for (final field in fields) {
      final fieldName = field['name'] as String;

      final typeStr = field['type'] as String;

      final dartType = _toDartType(field);

      final isNullable = dartType.endsWith('?');

      String mapping;

      if (typeStr == 'autodate' || typeStr == 'date') {
        if (isNullable) {
          mapping = "$fieldName?.toIso8601String()";
        } else {
          mapping = "$fieldName.toIso8601String()";
        }
      } else {
        mapping = fieldName;
      }

      buffer.writeln("    '$fieldName': $mapping,");
    }

    buffer.writeln("  };");
    buffer.writeln();
  }

  void _writeCopyWith(
    StringBuffer buffer,
    String className,
    List<dynamic> fields,
  ) {
    buffer.writeln("  $className copyWith({");
    for (final field in fields) {
      final fieldName = field['name'] as String;
      final dartType = _toDartType(field);

      // Ensure the parameter is nullable even if the field isn't
      final paramType = dartType.endsWith('?') ? dartType : '$dartType?';
      buffer.writeln("    $paramType $fieldName,");
    }
    buffer.writeln("  }) {");
    buffer.writeln("    return $className(");
    for (final field in fields) {
      final fieldName = field['name'] as String;
      buffer.writeln("      $fieldName: $fieldName ?? this.$fieldName,");
    }
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln();
  }

  void _writeEquality(
    StringBuffer buffer,
    String className,
    List<dynamic> fields,
  ) {
    buffer.writeln("  @override");
    buffer.writeln("  bool operator ==(Object other) =>");
    buffer.writeln("      identical(this, other) ||");
    buffer.writeln("      other is $className &&");
    buffer.writeln("          runtimeType == other.runtimeType &&");
    for (var i = 0; i < fields.length; i++) {
      final field = fields[i];
      final fieldName = field['name'] as String;
      final dartType = _toDartType(field);
      final isList = dartType.startsWith('List<');
      final suffix = (i == fields.length - 1) ? ";" : " &&";
      if (isList) {
        buffer.writeln(
          "          _listEquals($fieldName, other.$fieldName)$suffix",
        );
      } else {
        buffer.writeln("          $fieldName == other.$fieldName$suffix");
      }
    }

    buffer.writeln();
  }

  void _writeHashCode(StringBuffer buffer, List<dynamic> fields) {
    buffer.writeln("  @override");

    buffer.writeln("  int get hashCode => Object.hashAll([");

    for (final field in fields) {
      final fieldName = field['name'] as String;

      final dartType = _toDartType(field);

      final isList = dartType.startsWith('List<');

      if (isList) {
        buffer.writeln("        Object.hashAll($fieldName),");
      } else {
        buffer.writeln("        $fieldName,");
      }
    }

    buffer.writeln("      ]);");

    buffer.writeln();
  }

  void _writeStaticHelper(
    StringBuffer buffer,
    String className,
    String collectionName,
  ) {
    buffer.writeln(
      "  static CollectionHelper<$className> helper(PocketBase pb) =>",
    );
    buffer.writeln(
      "      CollectionHelper(pb, collection: '$collectionName', mapper: $className.fromMap);",
    );
  }

  void _writeFooter(StringBuffer buffer) {
    buffer.writeln();

    final hasLists = schema.any(
      (collection) => (collection['fields'] as List).any(
        (field) => _toDartType(field).startsWith('List<'),
      ),
    );

    if (hasLists) {
      buffer.writeln("bool _listEquals<T>(List<T>? a, List<T>? b) {");
      buffer.writeln("  if (a == null) return b == null;");
      buffer.writeln("  if (b == null || a.length != b.length) return false;");
      buffer.writeln("  if (identical(a, b)) return true;");
      buffer.writeln("  for (int index = 0; index < a.length; index++) {");
      buffer.writeln("    if (a[index] != b[index]) return false;");
      buffer.writeln("  }");
      buffer.writeln("  return true;");
      buffer.writeln("}");
    }
  }

  String _singularize(String name) {
    if (name.endsWith('ies')) return '${name.substring(0, name.length - 3)}y';
    if (name.endsWith('s') && !name.endsWith('ss')) {
      return name.substring(0, name.length - 1);
    }

    return name;
  }

  String _pluralize(String name) {
    if (name.endsWith('s')) return name;
    if (name.endsWith('y')) return '${name.substring(0, name.length - 1)}ies';

    return '${name}s';
  }

  String _toClassName(String name) {
    if (name.startsWith('_')) name = name.substring(1);
    return name
        .split('_')
        .map((s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1))
        .join('');
  }

  String _toDartType(dynamic field) {
    final type = field['type'] as String;
    final required = field['required'] == true || field['system'] == true;
    final suffix = required ? '' : '?';

    switch (type) {
      case 'text':
      case 'email':
      case 'url':
      case 'password':
      case 'editor':
        return 'String$suffix';
      case 'number':
        return 'double$suffix';
      case 'bool':
        return 'bool$suffix';
      case 'date':
      case 'autodate':
        return 'DateTime$suffix';
      case 'json':
        return 'dynamic';
      case 'relation':
      case 'file':
      case 'select':
        final maxSelect = field['maxSelect'] ?? 1;

        if (maxSelect == 1) return 'String$suffix';

        return 'List<String>';

      default:
        return 'dynamic';
    }
  }
}
