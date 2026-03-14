import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart';
import 'package:pocketbase_helpers_cli/src/generator.dart';
import 'package:test/test.dart';

void main() {
  Library genLibrary(
    String type, {
    bool required = false,
    int maxSelect = 1,
    String? name,
    String? collectionType,
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
            'maxSelect': maxSelect,
          },
        ],
      },
    ];

    return ModelGenerator(schema: schema).buildLibrary();
  }

  String emit(Spec spec) {
    final emitter = DartEmitter();
    return spec.accept(emitter).toString();
  }

  void expectField(
    Class cls, {
    required String name,
    required bool requiredConstructor,
    required String type,
    required String fromMap,
    required String toMap,
    required String copyWithParam,
    required String copyWithAssign,
  }) {
    String normalize(String s) => s.replaceAll(RegExp(r'\s+'), '');

    // Check Field Declaration
    final field = cls.fields.firstWhere((f) => f.name == name);
    expect(field.type?.symbol, type);
    expect(field.modifier, FieldModifier.final$);

    // Check constructor
    final constructor = cls.constructors.first;
    expect(constructor.requiredParameters, isEmpty);
    expect(
      constructor.optionalParameters.any(
        (p) =>
            p.required == requiredConstructor && p.name == name.toCamelCase(),
      ),
      isTrue,
    );

    // Check fromMap mapping
    final fromMapMethod = cls.methods.firstWhere((m) => m.name == 'fromMap');
    final fromMapSource = normalize(emit(fromMapMethod));
    expect(fromMapSource, contains('f:${normalize(fromMap)}'));

    // Check toMap mapping
    final toMapMethod = cls.methods.firstWhere((m) => m.name == 'toMap');
    final toMapSource = normalize(emit(toMapMethod));
    expect(toMapSource, contains("'$name':${normalize(toMap)}"));

    // Check copyWith
    final copyWithMethod = cls.methods.firstWhere((m) => m.name == 'copyWith');
    final copyWithSource = normalize(emit(copyWithMethod));
    expect(copyWithSource, contains(normalize(copyWithParam)));
    expect(copyWithSource, contains('f:${normalize(copyWithAssign)}'));
  }

  group('Plaintext', () {
    void testStringType(String type) {
      group(type, () {
        test('required', () {
          final lib = genLibrary(type, required: true);
          final cls = lib.body.whereType<Class>().first;

          expectField(
            cls,
            requiredConstructor: true,
            name: 'f',
            type: 'String',
            fromMap: "(map['f'] as String)",
            toMap: 'f',
            copyWithParam: 'String? f',
            copyWithAssign: 'f ?? this.f',
          );
        });

        test('optional', () {
          final lib = genLibrary(type, required: false);
          final cls = lib.body.whereType<Class>().first;

          expectField(
            cls,
            requiredConstructor: false,
            name: 'f',
            type: 'String?',
            fromMap: "(map['f'] as String?)",
            toMap: 'f',
            copyWithParam: 'String? f',
            copyWithAssign: 'f ?? this.f',
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
      final lib = genLibrary('number', required: true);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: true,
        name: 'f',
        type: 'double',
        fromMap: "(map['f'] as num).toDouble()",
        toMap: 'f',
        copyWithParam: 'double? f',
        copyWithAssign: 'f ?? this.f',
      );
    });

    test('optional', () {
      final lib = genLibrary('number', required: false);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: false,
        name: 'f',
        type: 'double?',
        fromMap: "map['f'] != null ? (map['f'] as num).toDouble() : null",
        toMap: 'f',
        copyWithParam: 'double? f',
        copyWithAssign: 'f ?? this.f',
      );
    });
  });

  group('bool', () {
    test('always required', () {
      final lib = genLibrary('bool', required: false);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: true,
        name: 'f',
        type: 'bool',
        fromMap: "(map['f'] as bool)",
        toMap: 'f',
        copyWithParam: 'bool? f',
        copyWithAssign: 'f ?? this.f',
      );
    });
  });

  group('date', () {
    test('required', () {
      final lib = genLibrary('date', required: true);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: true,
        name: 'f',
        type: 'DateTime',
        fromMap: "DateTime.parse((map['f'] as String))",
        toMap: 'f.toIso8601String()',
        copyWithParam: 'DateTime? f',
        copyWithAssign: 'f ?? this.f',
      );
    });

    test('optional', () {
      final lib = genLibrary('date', required: false);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: false,
        name: 'f',
        type: 'DateTime?',
        fromMap:
            "map['f'] != null ? DateTime.parse((map['f'] as String)) : null",
        toMap: 'f?.toIso8601String()',
        copyWithParam: 'DateTime? f',
        copyWithAssign: 'f ?? this.f',
      );
    });
  });

  void testSelectable(String type) {
    group(type, () {
      test('single required', () {
        final lib = genLibrary(type, required: true);
        final cls = lib.body.whereType<Class>().first;

        expectField(
          cls,
          requiredConstructor: true,
          name: 'f',
          type: 'String',
          fromMap: "(map['f'] as String)",
          toMap: 'f',
          copyWithParam: 'String? f',
          copyWithAssign: 'f ?? this.f',
        );
      });

      test('single optional', () {
        final lib = genLibrary(type);
        final cls = lib.body.whereType<Class>().first;

        expectField(
          cls,
          requiredConstructor: false,
          name: 'f',
          type: 'String?',
          fromMap: "(map['f'] as String?)",
          toMap: 'f',
          copyWithParam: 'String? f',
          copyWithAssign: 'f ?? this.f',
        );
      });

      test('multi', () {
        final lib = genLibrary(type, maxSelect: 2);
        final cls = lib.body.whereType<Class>().first;

        expectField(
          cls,
          requiredConstructor: true,
          name: 'f',
          type: 'List<String>',
          fromMap:
              "(map['f'] as List<dynamic>).map((e) => (e as String)).toList()",
          toMap: 'f',
          copyWithParam: 'List<String>? f',
          copyWithAssign: 'f ?? this.f',
        );
      });
    });
  }

  testSelectable('select');
  testSelectable('file');
  testSelectable('relation');

  group('json', () {
    test('dynamic', () {
      final lib = genLibrary('json');
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: false,
        name: 'f',
        type: 'dynamic',
        fromMap: "map['f']",
        toMap: 'f',
        copyWithParam: 'dynamic f',
        copyWithAssign: 'f ?? this.f',
      );
    });
  });

  group('geoPoint', () {
    test('required', () {
      final lib = genLibrary('geoPoint', required: true);
      final cls = lib.body.whereType<Class>().first;

      expectField(
        cls,
        requiredConstructor: true,
        name: 'f',
        type: 'GeoPoint',
        fromMap: "GeoPoint.fromMap(map['f'])",
        toMap: 'f.toMap()',
        copyWithParam: 'GeoPoint? f',
        copyWithAssign: 'f ?? this.f',
      );
    });
  });

  group('hidden fields', () {
    test('hidden field is not generated', () {
      final schema = [
        {
          'name': 't',
          'type': 'base',
          'fields': [
            {'name': 'visible', 'type': 'text'},
            {'name': 'secret', 'type': 'text', 'hidden': true},
          ],
        },
      ];

      final lib = ModelGenerator(schema: schema).buildLibrary();
      final cls = lib.body.whereType<Class>().first;

      expect(cls.fields.any((f) => f.name == 'visible'), isTrue);
      expect(cls.fields.any((f) => f.name == 'secret'), isFalse);
    });
  });

  group('Files', () {
    test('single field generates static helper', () {
      final lib = genLibrary('file', maxSelect: 1);

      final cls = lib.body
          .whereType<Class>()
          .where((c) => c.name == 'Cs')
          .first;

      expect(
        cls.methods.any(
          (m) =>
              m.name == 'fApi' &&
              m.returns?.symbol == 'SingleFileHelper<C>' &&
              m.static,
        ),
        isTrue,
      );
    });

    test('multi field generates static helper', () {
      final lib = genLibrary('file', maxSelect: 4);

      final cls = lib.body
          .whereType<Class>()
          .where((c) => c.name == 'Cs')
          .first;

      expect(
        cls.methods.any(
          (m) =>
              m.name == 'fApi' &&
              m.returns?.symbol == 'MultiFileHelper<C>' &&
              m.static,
        ),
        isTrue,
      );
    });
  });

  group('Auth', () {
    late Library lib;

    setUp(() {
      lib = genLibrary('text', name: 'User', collectionType: 'auth');
    });

    test('Has auth helper', () {
      final cls = lib.body
          .whereType<Class>()
          .where((c) => c.name == 'Users')
          .first;

      expect(
        cls.methods.any(
          (m) =>
              m.name == 'auth' &&
              m.returns?.symbol == 'AuthHelper<User>' &&
              m.static,
        ),
        isTrue,
      );
    });

    test('Has authentication checks', () {
      final cls = lib.body
          .whereType<Class>()
          .where((c) => c.name == 'User')
          .first;

      expect(
        cls.methods.any(
          (m) =>
              m.name == 'isAuthenticated' &&
              m.returns?.symbol == 'bool' &&
              m.static,
        ),
        isTrue,
      );

      expect(
        cls.methods.any(
          (m) =>
              m.name == 'getAuthenticated' &&
              m.returns?.symbol == 'User' &&
              m.static,
        ),
        isTrue,
      );
    });
  });
}
