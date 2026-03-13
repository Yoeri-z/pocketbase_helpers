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
      required ||
      system ||
      isList ||
      type == 'autodate' ||
      type == 'bool' ||
      type == 'password';

  bool get isList =>
      (type == 'relation' || type == 'file' || type == 'select') &&
      maxSelect > 1;

  String get fieldName => name.toCamelCase();

  String get dartType {
    if (isList) return 'List<String>';
    final suffix = isDartRequired ? '?' : '';

    return switch (type) {
      'text' || 'email' || 'url' || 'editor' || 'password' => 'String$suffix',
      'number' => 'double$suffix',
      'bool' => 'bool$suffix',
      'date' || 'autodate' => 'DateTime$suffix',
      'relation' ||
      'file' ||
      'select' => isList ? 'List<String>' : 'String$suffix',
      'geoPoint' => 'GeoPoint',
      //includes json
      _ => 'dynamic',
    };
  }
}
