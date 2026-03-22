import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'package:pocketbase_helpers_cli/src/field.dart';
import 'package:pocketbase_helpers_cli/src/field_mapper.dart';

import 'collection.dart';

enum JsonMapBehavior { fromJson, fromMap, none }

/// Generator for PocketBase models from a pb_schema.json file.
class ModelGenerator {
  /// Create a Model generator
  const ModelGenerator({
    required this.schema,
    this.jsonMapBehavior = JsonMapBehavior.none,
  });

  /// The jsonDecoded pocketbase schema
  final List<dynamic> schema;

  final JsonMapBehavior jsonMapBehavior;

  /// Generate the class definitions from [schema] as a string.
  String generate() {
    final library = buildLibrary();
    final emitter = DartEmitter(
      allocator: Allocator.none,
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    final source = library.accept(emitter).toString();
    final formatter = DartFormatter(languageVersion: .new(3, 0, 0));
    return formatter.format(source);
  }

  /// Build the [Library] for the schema.
  Library buildLibrary() {
    return Library(
      (l) => l
        ..comments.addAll([
          'GENERATED CODE - DO NOT MODIFY BY HAND',
          'This file contains custom json serializable models.',
          'add a `serializables_spec.dart` file next to this file to add imports for the missing types',
        ])
        ..directives.addAll([
          if (jsonMapBehavior == .none)
            Directive.import('package:pocketbase/pocketbase.dart'),
          if (jsonMapBehavior == .none)
            Directive.import(
              'package:pocketbase_helpers/pocketbase_helpers.dart',
            ),
          if (jsonMapBehavior != .none)
            Directive.partOf('serializables_spec.dart'),
        ])
        ..body.addAll(_generateLibraryBody()),
    );
  }

  Iterable<Spec> _generateLibraryBody() sync* {
    bool hasLists = false;
    final List<PocketBaseCollection> collections = [];
    for (final collectionData in schema) {
      final collection = PocketBaseCollection(collectionData);

      if (collection.isPrivate) continue;

      collections.add(collection);

      final fields = collection.fields.where((f) => !f.hidden).toList();

      if (fields.any((f) => f.isList)) {
        hasLists = true;
      }

      yield* _generateCollectionSpecs(collection, fields);
    }

    yield _generateStaticCollectionsClass(collections);

    if (hasLists) {
      yield _generateListEquals();
    }
  }

  Class _generateStaticCollectionsClass(
    List<PocketBaseCollection> collections,
  ) {
    return Class(
      (c) => c
        ..name = 'Collection'
        ..docs.add(
          '/// Static class containing all the string literals for your pocketbase collections.',
        )
        ..modifier = .final$
        ..abstract = true
        ..fields.addAll([
          for (final collection in collections)
            Field(
              (f) => f
                ..docs.add(
                  '/// The name of the `${collection.name}` collection.',
                )
                ..name = collection.fieldName
                ..static = true
                ..modifier = .constant
                ..type = refer('String')
                ..assignment = literalString(collection.name).code,
            ),
        ]),
    );
  }

  Iterable<Spec> _generateCollectionSpecs(
    PocketBaseCollection collection,
    List<PocketBaseField> fields,
  ) sync* {
    yield _generateModelClass(collection, fields);

    if (collection.className != collection.helperClassName) {
      yield _generateHelperClass(collection);
    }
  }

  Class _generateModelClass(
    PocketBaseCollection collection,
    List<PocketBaseField> fields,
  ) {
    final mappers = {
      for (final field in fields)
        field: FieldMapper.forField(field, jsonMapBehavior),
    };

    return Class((c) {
      c
        ..name = collection.className
        ..docs.add('/// Model for the `${collection.name}` collection.')
        ..implements.add(refer('PocketBaseRecord'))
        ..fields.addAll(fields.map((f) => _generateField(f, mappers[f]!)))
        ..constructors.addAll([_generateConstructor(fields)])
        ..methods.addAll([
          _generateFromMap(collection, fields, mappers),
          _generateToMap(fields, mappers),
          _generateCopyWith(collection, fields, mappers),
          _generateGetFile(collection),
          _generateEquality(collection, fields),
          _generateHashCodeGetter(fields),
          if (collection.isAuth) _generateIsAuthenticated(collection),
          if (collection.isAuth) _generateGetAuthenticated(collection),
        ]);

      if (collection.className == collection.helperClassName) {
        c.fields.addAll(_generateStaticHelperFields(collection));
        c.methods.addAll(_generateStaticHelperMethods(collection));
      }
    });
  }

  Class _generateHelperClass(PocketBaseCollection collection) {
    return Class(
      (c) => c
        ..name = collection.helperClassName
        ..docs.add('/// Helper for the `${collection.name}` collection.')
        ..abstract = true
        ..modifier = .final$
        ..fields.addAll(_generateStaticHelperFields(collection))
        ..methods.addAll(_generateStaticHelperMethods(collection)),
    );
  }

  Field _generateField(PocketBaseField field, FieldMapper mapper) {
    return Field(
      (f) => f
        ..name = field.fieldName
        ..modifier = .final$
        ..type = mapper.type
        ..annotations.addAll([if (field.fieldName == 'id') refer('override')]),
    );
  }

  Constructor _generateConstructor(List<PocketBaseField> fields) {
    return Constructor(
      (c) => c
        ..optionalParameters.addAll(
          fields.map((field) {
            return Parameter(
              (p) => p
                ..name = field.fieldName
                ..toThis = true
                ..named = true
                ..required = field.isDartRequired,
            );
          }),
        ),
    );
  }

  Method _generateFromMap(
    PocketBaseCollection collection,
    List<PocketBaseField> fields,
    Map<PocketBaseField, FieldMapper> mappers,
  ) {
    return Method(
      (m) => m
        ..name = 'fromMap'
        ..static = true
        ..returns = refer(collection.className)
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'map'
              ..type = refer('Map<String, dynamic>'),
          ),
        )
        ..body = refer(collection.className)
            .newInstance([], {
              for (final field in fields)
                field.fieldName: mappers[field]!.mapToField(
                  refer('map').index(literalString(field.name)),
                ),
            })
            .returned
            .statement,
    );
  }

  Method _generateToMap(
    List<PocketBaseField> fields,
    Map<PocketBaseField, FieldMapper> mappers,
  ) {
    final map = <String, Expression>{};
    for (final field in fields) {
      map[field.name] = mappers[field]!.fieldToMap(refer(field.fieldName));
    }

    return Method(
      (m) => m
        ..name = 'toMap'
        ..annotations.add(refer('override'))
        ..returns = refer('Map<String, dynamic>')
        ..lambda = true
        ..body = literalMap(map).code,
    );
  }

  Method _generateIsAuthenticated(PocketBaseCollection collection) {
    return Method(
      (m) => m
        ..name = 'isAuthenticated'
        ..static = true
        ..returns = refer('bool')
        ..docs.add(
          '/// Check whether or not the user is authenticated to the `${collection.name}` collection',
        )
        ..optionalParameters.add(
          Parameter(
            (p) => p
              ..name = 'pocketBaseInstance'
              ..type = refer('PocketBase?')
              ..named = false
              ..required = false,
          ),
        )
        ..body = Block(
          (b) => b.statements.addAll([
            declareFinal('pb')
                .assign(
                  refer(
                    'pocketBaseInstance',
                  ).ifNullThen(refer('PocketBaseConnection').property('pb')),
                )
                .statement,

            // return pb.authStore.isValid && pb.authStore.record?.collectionName == 'collectionName';
            refer('pb')
                .property('authStore')
                .property('isValid')
                .and(
                  refer('pb')
                      .property('authStore')
                      .property('record')
                      .nullSafeProperty('collectionName')
                      .equalTo(literalString(collection.name)),
                )
                .returned
                .statement,
          ]),
        ),
    );
  }

  Method _generateGetAuthenticated(PocketBaseCollection collection) {
    return Method(
      (m) => m
        ..name = 'getAuthenticated'
        ..static = true
        ..returns = refer(collection.className)
        ..docs.add(
          '/// Returns the currently authenticated `${collection.className}`.',
        )
        ..docs.add(
          '/// Throws an assertion error if the user is not authenticated to this collection.',
        )
        ..optionalParameters.add(
          Parameter(
            (p) => p
              ..name = 'pocketBaseInstance'
              ..type = refer('PocketBase?')
              ..named = false
              ..required = false,
          ),
        )
        ..body = Block(
          (b) => b.statements.addAll([
            declareFinal('pb')
                .assign(
                  refer(
                    'pocketBaseInstance',
                  ).ifNullThen(refer('PocketBaseConnection').property('pb')),
                )
                .statement,

            refer('assert').call([
              refer('isAuthenticated').call([refer('pb')]),
              literalString('User is not authenticated yet.'),
            ]).statement,

            refer('fromMap')
                .call([
                  refer('HelperUtils').property('getRecordJson').call([
                    refer(
                      'pb',
                    ).property('authStore').property('record').nullChecked,
                  ]),
                ])
                .returned
                .statement,
          ]),
        ),
    );
  }

  Method _generateCopyWith(
    PocketBaseCollection collection,
    List<PocketBaseField> fields,
    Map<PocketBaseField, FieldMapper> mappers,
  ) {
    return Method(
      (m) => m
        ..name = 'copyWith'
        ..returns = refer(collection.className)
        ..optionalParameters.addAll(
          fields.where((f) => f.type != 'autodate').map((field) {
            return Parameter(
              (p) => p
                ..name = field.fieldName
                ..type = mappers[field]!.copyWithParamType
                ..named = true,
            );
          }),
        )
        ..body = refer(collection.className)
            .newInstance([], {
              for (final field in fields)
                field.fieldName: field.type == 'autodate'
                    ? refer(field.fieldName)
                    : refer(
                        field.fieldName,
                      ).ifNullThen(refer('this').property(field.fieldName)),
            })
            .returned
            .statement,
    );
  }

  Method _generateGetFile(PocketBaseCollection collection) {
    return Method(
      (m) => m
        ..docs.add(
          '/// Get a file attached to this record with the name [fileName]',
        )
        ..returns = refer('Uri')
        ..name = 'getFileUrl'
        ..optionalParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'fileName'
              ..type = refer('String')
              ..named = false
              ..required = true,
          ),
          Parameter(
            (p) => p
              ..name = 'pocketBaseInstance'
              ..type = refer('PocketBase?')
              ..named = true
              ..required = false,
          ),
        ])
        ..lambda = true
        ..body = refer('HelperUtils')
            .property('buildFileUrl')
            .call(
              [literalString(collection.name), refer('id'), refer('fileName')],
              {'pocketBaseInstance': refer('pocketBaseInstance')},
            )
            .code,
    );
  }

  Method _generateEquality(
    PocketBaseCollection collection,
    List<PocketBaseField> fields,
  ) {
    final expressions = <Expression>[
      refer('other').isA(refer(collection.className)),
      refer('runtimeType').equalTo(refer('other').property('runtimeType')),
    ];

    for (final field in fields) {
      if (field.isList) {
        expressions.add(
          refer('_listEquals').call([
            refer(field.fieldName),
            refer('other').property(field.fieldName),
          ]),
        );
      } else {
        expressions.add(
          refer(
            field.fieldName,
          ).equalTo(refer('other').property(field.fieldName)),
        );
      }
    }

    return Method(
      (m) => m
        ..name = 'operator =='
        ..annotations.add(refer('override'))
        ..returns = refer('bool')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'other'
              ..type = refer('Object'),
          ),
        )
        ..body = refer('identical')
            .call([refer('this'), refer('other')])
            .or(expressions.reduce((a, b) => a.and(b)))
            .code,
    );
  }

  Method _generateHashCodeGetter(List<PocketBaseField> fields) {
    final hashValues = fields.map((field) {
      if (field.isList) {
        return refer(
          'Object',
        ).property('hashAll').call([refer(field.fieldName)]);
      }
      return refer(field.fieldName);
    }).toList();

    return Method(
      (m) => m
        ..name = 'hashCode'
        ..type = MethodType.getter
        ..annotations.add(refer('override'))
        ..returns = refer('int')
        ..body = refer(
          'Object',
        ).property('hashAll').call([literalList(hashValues)]).code,
    );
  }

  Iterable<Method> _generateStaticHelperMethods(
    PocketBaseCollection collection,
  ) sync* {
    yield Method(
      (m) => m
        ..name = 'api'
        ..static = true
        ..docs.add(
          '///Gets the [CollectionHelper] for the `${collection.name}` collection',
        )
        ..returns = refer('CollectionHelper<${collection.className}>')
        ..optionalParameters.add(
          Parameter(
            (p) => p
              ..name = 'pocketbaseInstance'
              ..type = refer('PocketBase?'),
          ),
        )
        ..lambda = true
        ..body = refer('CollectionHelper').newInstance([], {
          'pocketBaseInstance': refer('pocketbaseInstance'),
          'collection': literalString(collection.name),
          'mapper': refer(collection.className).property('fromMap'),
        }).code,
    );

    yield Method(
      (m) => m
        ..name = 'realtime'
        ..static = true
        ..docs.add(
          '/// Gets the [RealtimeHelper] for the `${collection.name}` collection',
        )
        ..returns = refer('RealtimeHelper')
        ..optionalParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'pocketbaseInstance'
              ..type = refer('PocketBase?'),
          ),
          Parameter(
            (p) => p
              ..name = 'debounce'
              ..type = refer('Duration?'),
          ),
        ])
        ..lambda = true
        ..body = refer('RealtimeHelper').newInstance([], {
          'pocketBaseInstance': refer('pocketbaseInstance'),
          'collection': literalString(collection.name),
          'mapper': refer(collection.className).property('fromMap'),
          'debounce': refer('debounce'),
        }).code,
    );

    if (collection.isAuth) {
      yield Method(
        (m) => m
          ..name = 'auth'
          ..static = true
          ..docs.add(
            '///Gets the [AuthHelper] for the `${collection.name}` collection',
          )
          ..returns = refer('AuthHelper<${collection.className}>')
          ..optionalParameters.add(
            Parameter(
              (p) => p
                ..name = 'pocketbaseInstance'
                ..type = refer('PocketBase?'),
            ),
          )
          ..lambda = true
          ..body = refer('AuthHelper').newInstance([], {
            'pocketBaseInstance': refer('pocketbaseInstance'),
            'collection': literalString(collection.name),
            'mapper': refer(collection.className).property('fromMap'),
          }).code,
      );
    }

    for (final field in collection.fields) {
      if (!field.isFileField) continue;

      final helperType = field.isList ? 'MultiFileHelper' : 'SingleFileHelper';

      yield Method(
        (m) => m
          ..docs.add('/// Access the file api for the `${field.name}` field')
          ..returns = refer('$helperType<${collection.className}>')
          ..name = '${field.fieldName}Api'
          ..static = true
          ..requiredParameters.addAll([
            Parameter(
              (p) => p
                ..type = refer('String')
                ..name = 'id'
                ..named = false,
            ),
          ])
          ..body = refer('FileHelper')
              .newInstance(
                [],
                {
                  'collection': literalString(collection.name),
                  'id': refer('id'),
                  'field': literalString(field.name),
                  'mapper': refer(collection.className).property('fromMap'),
                },
                [refer(collection.className)],
              )
              .code,
      );
    }
  }

  Iterable<Field> _generateStaticHelperFields(
    PocketBaseCollection collection,
  ) sync* {
    yield Field(
      (f) => f
        ..docs.add('/// The name of this collection in PocketBase.')
        ..name = 'collectionName'
        ..static = true
        ..modifier = .constant
        ..type = refer('String')
        ..assignment = literalString(collection.name).code,
    );
  }

  Spec _generateListEquals() {
    return Method(
      (m) => m
        ..name = '_listEquals'
        ..types.add(refer('T'))
        ..returns = refer('bool')
        ..requiredParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'a'
              ..type = refer('List<T>?'),
          ),
          Parameter(
            (p) => p
              ..name = 'b'
              ..type = refer('List<T>?'),
          ),
        ])
        ..body = Block(
          (b) => b.statements.addAll([
            const Code('if (a == null) return b == null;'),
            const Code('if (b == null || a.length != b.length) return false;'),
            const Code('if (identical(a, b)) return true;'),
            const Code(
              'for (int index = 0; index < a.length; index++) { if (a[index] != b[index]) return false; }',
            ),
            const Code('return true;'),
          ]),
        ),
    );
  }
}
