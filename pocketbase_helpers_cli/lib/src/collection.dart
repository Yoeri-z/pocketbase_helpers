import 'package:change_case/change_case.dart';

import 'field.dart';
import 'utils.dart';

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
  bool get isAuth => type == 'auth';

  String get className => name.singularize().toPascalCase();
  String get fieldName => name.pluralize().toCamelCase();

  String get helperClassName => name.pluralize().toPascalCase();
}
