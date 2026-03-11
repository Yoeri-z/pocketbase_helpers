import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:pocketbase_helpers_cli/src/generator.dart';
import 'package:test/test.dart';

void main() {
  String gen(String type, {bool required = false, int maxSelect = 1}) {
    final schema = [
      {
        'name': 't',
        'fields': [
          {
            'name': 'f',
            'type': type,
            'required': required,
            'maxSelect': maxSelect,
          },
        ],
      },
    ];
    return ModelGenerator(schema: schema).generate();
  }

  void expectField({
    required String output,
    required String declaration,
    required String fromMap,
    required String toMap,
    required String copyWithParam,
    required String copyWithAssign,
  }) {
    expect(output, contains(declaration));
    expect(output, contains(fromMap));
    expect(output, contains(toMap));
    expect(output, contains(copyWithParam));
    expect(output, contains(copyWithAssign));
  }

  group('Plaintext', () {
    void testStringType(String type) {
      group(type, () {
        test('required', () {
          final out = gen(type, required: true);

          expectField(
            output: out,
            declaration: 'final String f;',
            fromMap: "map['f'] as String",
            toMap: "'f': f",
            copyWithParam: 'String? f',
            copyWithAssign: 'f: f ?? this.f',
          );
        });

        test('optional', () {
          final out = gen(type, required: false);

          expectField(
            output: out,
            declaration: 'final String? f;',
            fromMap: "map['f'] as String?",
            toMap: "'f': f",
            copyWithParam: 'String? f',
            copyWithAssign: 'f: f ?? this.f',
          );
        });
      });
    }

    testStringType('text');
    testStringType('editor');
    testStringType('email');
    testStringType('url');
  });

  group('number', () {
    test('required', () {
      final out = gen('number', required: true);

      expectField(
        output: out,
        declaration: 'final double f;',
        fromMap: "(map['f'] as num).toDouble()",
        toMap: "'f': f",
        copyWithParam: 'double? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });

    test('optional', () {
      final out = gen('number', required: false);

      expectField(
        output: out,
        declaration: 'final double? f;',
        fromMap: "map['f'] != null ? (map['f'] as num).toDouble() : null",
        toMap: "'f': f",
        copyWithParam: 'double? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });
  });

  group('bool', () {
    test('required', () {
      final out = gen('bool', required: true);

      expectField(
        output: out,
        declaration: 'final bool f;',
        fromMap: "map['f'] as bool",
        toMap: "'f': f",
        copyWithParam: 'bool? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });
  });

  group('date', () {
    test('required', () {
      final out = gen('date', required: true);

      expectField(
        output: out,
        declaration: 'final DateTime f;',
        fromMap: "DateTime.parse(map['f'] as String)",
        toMap: "'f': f.toIso8601String()",
        copyWithParam: 'DateTime? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });

    test('optional', () {
      final out = gen('date', required: false);

      expectField(
        output: out,
        declaration: 'final DateTime? f;',
        fromMap: "map['f'] != null ? DateTime.parse(map['f'] as String) : null",
        toMap: "'f': f?.toIso8601String()",
        copyWithParam: 'DateTime? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });
  });

  void testSelectable(String type) {
    group(type, () {
      test('single required', () {
        final out = gen(type, required: true);

        expectField(
          output: out,
          declaration: 'final String f;',
          fromMap: "map['f'] as String",
          toMap: "'f': f",
          copyWithParam: 'String? f',
          copyWithAssign: 'f: f ?? this.f',
        );
      });

      test('single optional', () {
        final out = gen(type);

        expectField(
          output: out,
          declaration: 'final String? f;',
          fromMap: "map['f'] as String?",
          toMap: "'f': f",
          copyWithParam: 'String? f',
          copyWithAssign: 'f: f ?? this.f',
        );
      });

      test('multi', () {
        final out = gen(type, maxSelect: 2);

        expectField(
          output: out,
          declaration: 'final List<String> f;',
          fromMap:
              "(map['f'] as List<dynamic>).map((e) => e as String).toList()",
          toMap: "'f': f",
          copyWithParam: 'List<String>? f',
          copyWithAssign: 'f: f ?? this.f',
        );
      });
    });
  }

  testSelectable('select');
  testSelectable('file');
  testSelectable('relation');

  group('json', () {
    test('dynamic', () {
      final out = gen('json');

      expectField(
        output: out,
        declaration: 'final dynamic f;',
        fromMap: "map['f']",
        toMap: "'f': f",
        copyWithParam: 'dynamic f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });
  });
  group('geoPoint', () {
    test('required', () {
      final out = gen('geoPoint', required: true);

      expectField(
        output: out,
        declaration: 'final GeoPoint f;',
        fromMap: "GeoPoint.fromMap(map['f'])",
        toMap: "'f': f.toMap()",
        copyWithParam: 'GeoPoint? f',
        copyWithAssign: 'f: f ?? this.f',
      );
    });
  });

  group('hidden fields', () {
    test('hidden field is not generated', () {
      final schema = [
        {
          'name': 't',
          'fields': [
            {'name': 'visible', 'type': 'text'},
            {'name': 'secret', 'type': 'text', 'hidden': true},
          ],
        },
      ];

      final out = ModelGenerator(schema: schema).generate();

      expect(out, contains('final String? visible;'));
      expect(out, isNot(contains('secret')));
    });
  });
  group('ModelGenerator static analysis', () {
    test('generated string is syntactically valid Dart', () {
      /// it was already verified that each variant of field is valid so we just need to test primitively different types
      final schema = [
        {
          'name': 'mega_test',
          'fields': [
            {'name': 'id', 'type': 'text', 'required': true, 'system': true},
            {'name': 'number_opt', 'type': 'number', 'required': false},
            {'name': 'bool_req', 'type': 'bool', 'required': true},
            {'name': 'date_opt', 'type': 'date', 'required': false},
            {'name': 'autodate_f', 'type': 'autodate', 'required': true},
            {'name': 'select_single', 'type': 'select', 'maxSelect': 1},
            {'name': 'select_multi', 'type': 'select', 'maxSelect': 3},
            {'name': 'json_field', 'type': 'json'},
            {'name': 'geo_field', 'type': 'geopoint'},
          ],
        },
      ];

      final generator = ModelGenerator(schema: schema);
      final String generatedCode = generator.generate();

      final ParseStringResult result = parseString(content: generatedCode);

      if (result.errors.isNotEmpty) {
        for (final error in result.errors) {
          print('Offset ${error.offset}: ${error.message}');
        }
      }

      expect(
        result.errors,
        isEmpty,
        reason: 'The generated code has syntax errors!',
      );
    });
  });
}
