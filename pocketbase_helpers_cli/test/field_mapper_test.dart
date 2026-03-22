import 'package:code_builder/code_builder.dart';
import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  String emit(Spec spec) {
    final emitter = DartEmitter();
    return spec.accept(emitter).toString();
  }

  String normalize(String s) => s.replaceAll(RegExp(r'\s+'), '');

  String fieldDecoder(FieldMapper mapper, String fieldLiteral) => normalize(
    emit(mapper.mapToField(refer('map').index(literalString(fieldLiteral)))),
  );

  String fieldEncoder(FieldMapper mapper, String fieldLiteral) =>
      normalize(emit(mapper.fieldToMap(refer(fieldLiteral))));

  test('text', () {
    final field = createField(type: 'text');
    final mapper = FieldMapper.forField(field, JsonMapBehavior.none);

    expect(mapper.type.symbol, 'String?');
    expect(fieldDecoder(mapper, 'f'), normalize("(map['f'] as String?)"));
    expect(fieldEncoder(mapper, 'f'), normalize('f'));
  });

  test('number required int', () {
    final field = createField(type: 'number', onlyInt: true, required: true);
    final mapper = FieldMapper.forField(field, JsonMapBehavior.none);

    expect(mapper.type.symbol, 'int');
    expect(fieldDecoder(mapper, 'f'), normalize("(map['f'] as num).toInt()"));
  });

  group('json', () {
    test('none (default)', () {
      final field = createField(type: 'json', name: 'config');
      final mapper = FieldMapper.forField(field, JsonMapBehavior.none);

      expect(mapper.type.symbol, 'dynamic');
      expect(fieldDecoder(mapper, 'config'), normalize("map['config']"));
      expect(fieldEncoder(mapper, 'config'), normalize('config'));
    });

    test('fromMap', () {
      final field = createField(type: 'json', name: 'config');
      final mapper = FieldMapper.forField(field, JsonMapBehavior.fromMap);

      expect(mapper.type.symbol, 'Config?');
      expect(
        fieldDecoder(mapper, 'config'),
        normalize(
          "map['config'] != null ? Config.fromMap((map['config'] as Map<String, dynamic>)) : null",
        ),
      );
      expect(fieldEncoder(mapper, 'config'), normalize('config?.toMap()'));
    });

    test('fromJson', () {
      final field = createField(type: 'json', name: 'config', required: true);
      final mapper = FieldMapper.forField(field, JsonMapBehavior.fromJson);

      expect(mapper.type.symbol, 'Config');
      expect(
        fieldDecoder(mapper, 'config'),
        normalize("Config.fromJson((map['config'] as Map<String, dynamic>))"),
      );
      expect(fieldEncoder(mapper, 'config'), normalize('config.toJson()'));
    });

    test('plural fromMap', () {
      final field = createField(type: 'json', name: 'items');
      final mapper = FieldMapper.forField(field, JsonMapBehavior.fromMap);

      expect(mapper.type.symbol, 'List<Item>?');
      expect(
        fieldDecoder(mapper, 'items'),
        normalize(
          "map['items'] != null ? (map['items'] as List<dynamic>).map((e) => Item.fromMap((e as Map<String, dynamic>))).toList() : null",
        ),
      );
      expect(
        fieldEncoder(mapper, 'items'),
        normalize('items?.map((e) => e.toMap()).toList()'),
      );
    });
  });
}
