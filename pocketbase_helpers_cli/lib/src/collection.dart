import 'package:change_case/change_case.dart';

import 'field.dart';

/// Wrapper for a PocketBase collection schema.
class PocketBaseCollection {
  PocketBaseCollection(this.data) {
    final fieldsData = data['fields'] as List<dynamic>?;
    if (fieldsData != null) {
      for (final field in fieldsData) {
        fields.add(PocketBaseField(field));
      }
    }
  }

  final dynamic data;

  String get name => data['name'] as String;
  String get type => data['type'] as String;

  List<PocketBaseField> fields = [];

  bool get isPrivate => name.startsWith('_');

  String get className => _singularize(name).toPascalCase();
  String get fieldName => _pluralize(name).toCamelCase();

  String get helperClassName => _pluralize(name).toPascalCase();

  static String _singularize(String name) {
    if (name.endsWith('ies')) return '${name.substring(0, name.length - 3)}y';
    if (name.endsWith('s') && !name.endsWith('ss')) {
      return name.substring(0, name.length - 1);
    }
    return name;
  }

  static String _pluralize(String name) {
    if (name.endsWith('s')) return name;
    if (name.endsWith('y')) return '${name.substring(0, name.length - 1)}ies';
    return '${name}s';
  }
}
