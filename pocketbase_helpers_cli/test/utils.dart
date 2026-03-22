import 'package:code_builder/code_builder.dart';
import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';
import 'package:pocketbase_helpers_cli/src/field.dart';

/// Emits a [Spec] into its Dart source code string.
String emit(Spec spec) {
  final emitter = DartEmitter();
  return spec.accept(emitter).toString();
}

/// Normalizes a string by removing all whitespace.
String normalize(String s) => s.replaceAll(RegExp(r'\s+'), '');

/// Creates a [PocketBaseField] from a raw map.
PocketBaseField createField({
  required String type,
  String name = 'f',
  bool required = false,
  int maxSelect = 1,
  bool onlyInt = false,
  Map<String, dynamic>? extra,
}) {
  return PocketBaseField({
    'name': name,
    'type': type,
    'required': required,
    'maxSelect': maxSelect,
    'onlyInt': onlyInt,
    if (extra != null) ...extra,
  });
}

/// Gets a [FieldMapper] for a given field and behavior.
FieldMapper getMapper(
  PocketBaseField field, {
  JsonMapBehavior behavior = JsonMapBehavior.none,
}) {
  return FieldMapper.forField(field, behavior);
}

/// Shortcut to get the Dart type symbol for a field configuration.
String getDartType({
  required String type,
  String name = 'f',
  bool required = false,
  int maxSelect = 1,
  bool onlyInt = false,
  Map<String, dynamic>? extra,
  JsonMapBehavior behavior = JsonMapBehavior.none,
}) {
  final field = createField(
    type: type,
    name: name,
    required: required,
    maxSelect: maxSelect,
    onlyInt: onlyInt,
    extra: extra,
  );
  return getMapper(field, behavior: behavior).type.symbol!;
}

/// Generates a [Library] for a single collection with a single field.
Library genLibrary(
  String type, {
  bool required = false,
  int maxSelect = 1,
  String? name,
  String? collectionType,
  bool onlyInt = false,
  JsonMapBehavior jsonMapBehavior = JsonMapBehavior.none,
}) {
  final schema = [
    {
      'name': name ?? 'c',
      'type': collectionType ?? 'base',
      'fields': [
        {
          'name': 'f',
          'type': type,
          'required': required,
          'onlyInt': onlyInt,
          'maxSelect': maxSelect,
        },
      ],
    },
  ];

  return ModelGenerator(schema: schema, jsonMapBehavior: jsonMapBehavior)
      .buildLibrary();
}
