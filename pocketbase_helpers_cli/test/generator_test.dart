import 'package:pocketbase_helpers_cli/generator.dart';
import 'package:test/test.dart';

void main() {
  group('ModelGenerator', () {
    test('generates correct types for all PocketBase field types', () {
      final schema = [
        {
          'name': 'mega_collection',
          'fields': [
            {'name': 'id', 'type': 'text', 'system': true, 'required': true},
            {'name': 'textField', 'type': 'text', 'required': false},
            {'name': 'emailField', 'type': 'email', 'required': true},
            {'name': 'urlField', 'type': 'url', 'required': false},
            {'name': 'numberField', 'type': 'number', 'required': true},
            {'name': 'boolField', 'type': 'bool', 'required': true},
            {'name': 'dateField', 'type': 'date', 'required': false},
            {'name': 'autodateField', 'type': 'autodate', 'system': true},
            {'name': 'jsonField', 'type': 'json', 'required': false},
            {
              'name': 'singleRelation',
              'type': 'relation',
              'maxSelect': 1,
              'required': false
            },
            {
              'name': 'multiRelation',
              'type': 'relation',
              'maxSelect': 2,
              'required': false
            },
            {'name': 'singleFile', 'type': 'file', 'maxSelect': 1},
            {'name': 'multiFile', 'type': 'file', 'maxSelect': 5},
            {'name': 'singleSelect', 'type': 'select', 'maxSelect': 1},
            {'name': 'multiSelect', 'type': 'select', 'maxSelect': 3},
          ]
        }
      ];

      final generator = ModelGenerator(schema: schema, outputFilePath: 'test.dart');
      final output = generator.generate();

      // Check class name
      expect(output, contains('class MegaCollection implements PocketBaseRecord'));

      // Check types
      expect(output, contains('final String id;'));
      expect(output, contains('final String? textField;'));
      expect(output, contains('final String emailField;'));
      expect(output, contains('final String? urlField;'));
      expect(output, contains('final double numberField;'));
      expect(output, contains('final bool boolField;'));
      expect(output, contains('final DateTime? dateField;'));
      expect(output, contains('final DateTime autodateField;'));
      expect(output, contains('final dynamic jsonField;'));
      expect(output, contains('final String? singleRelation;'));
      expect(output, contains('final List<String> multiRelation;'));
      expect(output, contains('final String? singleFile;'));
      expect(output, contains('final List<String> multiFile;'));
      expect(output, contains('final String? singleSelect;'));
      expect(output, contains('final List<String> multiSelect;'));

      // Check methods
      expect(output, contains('MegaCollection copyWith({'));
      expect(output, contains('bool operator ==(Object other)'));
      expect(output, contains('int get hashCode'));
      expect(output, contains('static CollectionHelper<MegaCollection> helper(PocketBase pb)'));
      
      // Check list equality helper inclusion
      expect(output, contains('bool _listEquals<T>(List<T>? a, List<T>? b)'));
    });

    test('omits _listEquals when no list fields are present', () {
      final schema = [
        {
          'name': 'simple_collection',
          'fields': [
            {'name': 'id', 'type': 'text', 'system': true, 'required': true},
            {'name': 'name', 'type': 'text', 'required': true},
          ]
        }
      ];

      final generator = ModelGenerator(schema: schema, outputFilePath: 'test.dart');
      final output = generator.generate();

      expect(output, isNot(contains('bool _listEquals')));
    });

    test('handles auth and system collection names correctly', () {
      final schema = [
        {'name': '_superusers', 'fields': []},
        {'name': 'users', 'fields': []},
      ];

      final generator = ModelGenerator(schema: schema, outputFilePath: 'test.dart');
      final output = generator.generate();

      expect(output, contains('class Superusers'));
      expect(output, contains('class Users'));
    });
  });
}
