import 'package:change_case/change_case.dart';

/// Wrapper for a PocketBase field schema.
class PocketBaseField {
  const PocketBaseField(this.data);

  final dynamic data;

  String get name => data['name'] as String;
  String get type => data['type'] as String;
  bool get required => data['required'] == true;
  bool get system => data['system'] == true;
  bool get hidden => data['hidden'] == true;
  int get maxSelect => data['maxSelect'] ?? 1;

  bool get isDartRequired =>
      required ||
      system ||
      isList ||
      type == 'autodate' ||
      type == 'bool' ||
      type == 'password' ||
      type == 'number' ||
      type == 'geoPoint';

  bool get isList =>
      (type == 'relation' || type == 'file' || type == 'select') &&
      maxSelect > 1;

  bool get isInt => data['onlyInt'] == true;

  bool get isFileField => type == 'file';

  String get fieldName => name.toCamelCase();
}
