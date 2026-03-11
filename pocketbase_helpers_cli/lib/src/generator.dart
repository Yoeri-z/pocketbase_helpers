/// Generator for PocketBase models from a pb_schema.json file.
class ModelGenerator {
  /// The jsonDecoded pocketbase schema
  final List<dynamic> schema;

  /// Create a Model generator
  ModelGenerator({required this.schema});

  /// Generate the class defenitions from [schema] as a string.
  String generate() {
    final buffer = StringBuffer();

    _writeHeader(buffer);

    _writeImports(buffer);

    for (final collection in schema) {
      if (_isPrivateCollection(collection)) continue;
      _writeClass(buffer, collection);
    }

    _writeFooter(buffer);

    return buffer.toString();
  }

  bool _isPrivateCollection(dynamic collection) =>
      (collection['name'] as String).startsWith('_');

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

    fields.removeWhere((f) => f['hidden'] == true);

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
    if (className == helperClassName) {
      _writeStaticHelper(buffer, className, name);
    }
    buffer.writeln("}");
    buffer.writeln();

    if (className != helperClassName) {
      buffer.writeln("/// Helper for the $name collection.");
      buffer.writeln("abstract final class $helperClassName {");
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
      final expression = _getMappingExpression(field);
      buffer.writeln("      $fieldName: $expression,");
    }

    buffer.writeln("    );");
    buffer.writeln("  }");
  }

  String _getMappingExpression(Map<String, dynamic> field) {
    final name = field['name'] as String;
    final type = field['type'] as String;
    final dartType = _toDartType(field);
    final isNullable = dartType.endsWith('?');
    final mapAccess = "map['$name']";

    switch (type) {
      case 'autodate':
      case 'date':
        return isNullable
            ? "$mapAccess != null ? DateTime.parse($mapAccess as String) : null"
            : "DateTime.parse($mapAccess as String)";

      case 'number':
        return isNullable
            ? "$mapAccess != null ? ($mapAccess as num).toDouble() : null"
            : "($mapAccess as num).toDouble()";

      case 'bool':
        return "$mapAccess as bool";

      case 'json':
        return mapAccess;

      case 'relation':
      case 'file':
      case 'select':
        final maxSelect = field['maxSelect'] ?? 1;
        if (maxSelect <= 1) {
          return "$mapAccess as String${isNullable ? '?' : ''}";
        }
        // Multi-select/file/relation
        return "($mapAccess as List<dynamic>).map((e) => e as String).toList()";
      case 'geoPoint':
        return "GeoPoint.fromMap($mapAccess)";
      default:
        return "$mapAccess as String${isNullable ? '?' : ''}";
    }
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
      } else if (typeStr == 'geoPoint') {
        mapping = "$fieldName.toMap()";
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
      // copy with on autodate does nothing so it might aswell not be available
      if (field['type'] == 'autodate') continue;

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
      if (field['type'] == 'autodate') {
        buffer.writeln("      $fieldName: $fieldName,");
      } else {
        buffer.writeln("      $fieldName: $fieldName ?? this.$fieldName,");
      }
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
      "  ///Get the [CollectionHelper] for the $collectionName collection",
    );
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
      case 'editor':
        return 'String$suffix';
      case 'password':
        return 'String';
      case 'number':
        return 'double$suffix';
      case 'bool':
        return 'bool$suffix';
      case 'date':
        return 'DateTime$suffix';
      case 'autodate':
        return 'DateTime';
      case 'json':
        return 'dynamic';
      case 'relation':
      case 'file':
      case 'select':
        final maxSelect = field['maxSelect'] ?? 1;

        if (maxSelect == 1) return 'String$suffix';

        return 'List<String>';
      case 'geoPoint':
        return 'GeoPoint';
      default:
        return 'dynamic';
    }
  }
}
