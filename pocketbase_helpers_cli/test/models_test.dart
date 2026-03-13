import 'package:pocketbase_helpers_cli/src/collection.dart';
import 'package:pocketbase_helpers_cli/src/field.dart';
import 'package:test/test.dart';

void main() {
  group('PocketBaseField', () {
    test('basic properties', () {
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

    test('isRequired logic', () {
      expect(
        PocketBaseField({'type': 'text', 'required': true}).isDartRequired,
        isTrue,
      );
      expect(
        PocketBaseField({'type': 'text', 'system': true}).isDartRequired,
        isTrue,
      );
      expect(PocketBaseField({'type': 'autodate'}).isDartRequired, isTrue);
      expect(
        PocketBaseField({'type': 'text', 'required': false}).isDartRequired,
        isFalse,
      );
    });

    test('isList logic', () {
      expect(
        PocketBaseField({'type': 'relation', 'maxSelect': 2}).isList,
        isTrue,
      );
      expect(PocketBaseField({'type': 'file', 'maxSelect': 2}).isList, isTrue);
      expect(
        PocketBaseField({'type': 'select', 'maxSelect': 2}).isList,
        isTrue,
      );
      expect(
        PocketBaseField({'type': 'relation', 'maxSelect': 1}).isList,
        isFalse,
      );
      expect(PocketBaseField({'type': 'text', 'maxSelect': 2}).isList, isFalse);
    });

    test('isNullable logic', () {
      expect(
        PocketBaseField({
          'type': 'text',
          'required': false,
          'system': false,
        }).isDartNullable,
        isTrue,
      );
      expect(
        PocketBaseField({'type': 'text', 'required': true}).isDartNullable,
        isFalse,
      );
      expect(
        PocketBaseField({'type': 'text', 'system': true}).isDartNullable,
        isFalse,
      );
      expect(PocketBaseField({'type': 'autodate'}).isDartNullable, isFalse);
    });

    group('dartType', () {
      test('text types', () {
        expect(
          PocketBaseField({'type': 'text', 'required': true}).dartType,
          'String',
        );
        expect(
          PocketBaseField({'type': 'text', 'required': false}).dartType,
          'String?',
        );
        expect(
          PocketBaseField({'type': 'email', 'required': true}).dartType,
          'String',
        );
        expect(
          PocketBaseField({'type': 'url', 'required': true}).dartType,
          'String',
        );
        expect(
          PocketBaseField({'type': 'editor', 'required': true}).dartType,
          'String',
        );
      });

      test('number', () {
        expect(
          PocketBaseField({'type': 'number', 'required': true}).dartType,
          'double',
        );
        expect(
          PocketBaseField({'type': 'number', 'required': false}).dartType,
          'double?',
        );
      });

      test('bool', () {
        expect(
          PocketBaseField({'type': 'bool', 'required': true}).dartType,
          'bool',
        );
      });

      test('date', () {
        expect(
          PocketBaseField({'type': 'date', 'required': true}).dartType,
          'DateTime',
        );
        expect(
          PocketBaseField({'type': 'date', 'required': false}).dartType,
          'DateTime?',
        );
        expect(PocketBaseField({'type': 'autodate'}).dartType, 'DateTime');
      });

      test('json', () {
        expect(PocketBaseField({'type': 'json'}).dartType, 'dynamic');
      });

      test('relation/file/select', () {
        expect(
          PocketBaseField({
            'type': 'relation',
            'maxSelect': 1,
            'required': true,
          }).dartType,
          'String',
        );
        expect(
          PocketBaseField({
            'type': 'relation',
            'maxSelect': 1,
            'required': false,
          }).dartType,
          'String?',
        );
        expect(
          PocketBaseField({'type': 'relation', 'maxSelect': 2}).dartType,
          'List<String>',
        );
      });

      test('geoPoint', () {
        expect(PocketBaseField({'type': 'geoPoint'}).dartType, 'GeoPoint');
      });
    });
  });

  group('PocketBaseCollection', () {
    test('basic properties', () {
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

    test('isPrivate', () {
      expect(PocketBaseCollection({'name': 'posts'}).isPrivate, isFalse);
      expect(PocketBaseCollection({'name': '_users'}).isPrivate, isTrue);
    });

    test('className and helperClassName', () {
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
  });
}
