import 'package:change_case/change_case.dart';

/// Wrapper for a PocketBase field schema.
class PocketBaseField {
  PocketBaseField(this.data);

  final dynamic data;

  String get name => data['name'] as String;
  String get type => data['type'] as String;
  bool get required => data['required'] == true;
  bool get system => data['system'] == true;
  bool get hidden => data['hidden'] == true;
  int get maxSelect => data['maxSelect'] ?? 1;

  bool get isDartRequired =>
      required || system || isList || type == 'autodate' || type == 'bool';

  bool get isList =>
      (type == 'relation' || type == 'file' || type == 'select') &&
      maxSelect > 1;

  bool get isDartNullable =>
      (!required && !system && type != 'autodate' && type != 'bool');

  String get fieldName => name.toCamelCase();

  String get dartType {
    if (isList) return 'List<String>';
    final suffix = isDartNullable ? '?' : '';

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
        if (maxSelect == 1) return 'String$suffix';
        return 'List<String>';
      case 'geoPoint':
        return 'GeoPoint';
      default:
        return 'dynamic';
    }
  }
}
