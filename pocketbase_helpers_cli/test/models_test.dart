import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';
import 'package:pocketbase_helpers_cli/src/collection.dart';
import 'package:pocketbase_helpers_cli/src/field.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('PocketBaseField', () {
    test('Correctly identifies basic properties', () {
      final field = PocketBaseField({
        'name': 'test_field',
        'type': 'text',
        'required': true,
        'system': false,
        'hidden': false,
      });

      expect(field.name, 'test_field');
      expect(field.type, 'text');
      expect(field.required, isTrue);
      expect(field.system, isFalse);
      expect(field.hidden, isFalse);
      expect(field.fieldName, 'testField');
    });

    test('Correctly handles isDartRequired logic', () {
      expect(createField(type: 'text', required: true).isDartRequired, isTrue);
      expect(
        createField(type: 'text', extra: {'system': true}).isDartRequired,
        isTrue,
      );
      expect(createField(type: 'autodate').isDartRequired, isTrue);
      expect(
        createField(type: 'text', required: false).isDartRequired,
        isFalse,
      );
    });

    test('Correctly handles isList logic', () {
      expect(createField(type: 'relation', maxSelect: 2).isList, isTrue);
      expect(createField(type: 'file', maxSelect: 2).isList, isTrue);
      expect(createField(type: 'select', maxSelect: 2).isList, isTrue);
      expect(createField(type: 'relation', maxSelect: 1).isList, isFalse);
      expect(createField(type: 'text', maxSelect: 2).isList, isFalse);
    });

    test('Correctly identifies non-nullable types in Dart', () {
      // Numbers are always required
      expect(
        createField(type: 'number', required: false).isDartRequired,
        isTrue,
      );
      // Booleans are always required
      expect(createField(type: 'bool', required: false).isDartRequired, isTrue);
      // Lists are always required
      expect(
        createField(
          type: 'relation',
          maxSelect: 2,
          required: false,
        ).isDartRequired,
        isTrue,
      );
    });

    group('Dart Type mapping via FieldMapper', () {
      test('Text and editor types', () {
        expect(getDartType(type: 'text', required: true), 'String');
        expect(getDartType(type: 'text', required: false), 'String?');
        expect(getDartType(type: 'email', required: true), 'String');
        expect(getDartType(type: 'url', required: true), 'String');
        expect(getDartType(type: 'editor', required: true), 'String');
      });

      test('Numeric types are always non-nullable', () {
        expect(getDartType(type: 'number', required: true), 'double');
        expect(getDartType(type: 'number', required: false), 'double');
        expect(
          getDartType(type: 'number', required: false, onlyInt: true),
          'int',
        );
      });

      test('Boolean is always non-nullable', () {
        expect(getDartType(type: 'bool', required: false), 'bool');
      });

      test('Date types', () {
        expect(getDartType(type: 'date', required: true), 'DateTime');
        expect(getDartType(type: 'date', required: false), 'DateTime?');
        expect(getDartType(type: 'autodate'), 'DateTime');
      });

      test('JSON mapping handles plurality', () {
        expect(getDartType(type: 'json'), 'dynamic');
        expect(
          getDartType(
            name: 'config',
            type: 'json',
            behavior: JsonMapBehavior.fromMap,
          ),
          'Config?',
        );
        expect(
          getDartType(
            name: 'items',
            type: 'json',
            behavior: JsonMapBehavior.fromMap,
          ),
          'List<Item>?',
        );
      });

      test('Selectable types', () {
        expect(
          getDartType(type: 'relation', maxSelect: 1, required: true),
          'String',
        );
        expect(
          getDartType(type: 'relation', maxSelect: 1, required: false),
          'String?',
        );
        expect(getDartType(type: 'relation', maxSelect: 2), 'List<String>');
      });

      test('GeoPoint', () {
        expect(getDartType(type: 'geoPoint'), 'GeoPoint');
      });
    });
  });

  group('PocketBaseCollection', () {
    test('Correctly identifies basic properties', () {
      final collection = PocketBaseCollection({
        'name': 'posts',
        'type': 'base',
        'fields': [
          {'name': 'title', 'type': 'text'},
        ],
      });

      expect(collection.name, 'posts');
      expect(collection.type, 'base');
      expect(collection.fields, hasLength(1));
      expect(collection.fields.first.name, 'title');
    });

    test('Correctly identifies private collections', () {
      expect(PocketBaseCollection({'name': 'posts'}).isPrivate, isFalse);
      expect(PocketBaseCollection({'name': '_users'}).isPrivate, isTrue);
    });

    test('Generates correct class and helper names', () {
      final posts = PocketBaseCollection({'name': 'posts'});
      expect(posts.className, 'Post');
      expect(posts.helperClassName, 'Posts');

      final categories = PocketBaseCollection({'name': 'categories'});
      expect(categories.className, 'Category');
      expect(categories.helperClassName, 'Categories');

      final news = PocketBaseCollection({'name': 'news'});
      expect(news.className, 'New');
      expect(news.helperClassName, 'News');
    });

    test('Identifies auth collections', () {
      expect(
        PocketBaseCollection({'name': 'posts', 'type': 'auth'}).isAuth,
        isTrue,
      );
      expect(
        PocketBaseCollection({'name': 'posts', 'type': 'base'}).isAuth,
        isFalse,
      );
    });
  });
}
