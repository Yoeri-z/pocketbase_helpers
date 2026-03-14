import 'dart:io';
import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'setup.dart';

void main() {
  test('buildFileUrl constructs correct URL', () {
    final pb = MockPocketBase();

    when(
      () => pb.buildURL(any(), any()),
    ).thenReturn(Uri.parse('http://localhost/file'));

    final url = HelperUtils.buildFileUrl(
      'dummy',
      'recordId',
      'file.png',
      pocketBaseInstance: pb,
    );

    expect(url.toString(), equals('http://localhost/file'));
    verify(
      () => pb.buildURL('api/files/dummy/recordId/file.png', {}),
    ).called(1);
  });
  test('cleanMap removes empty strings and recurses into nested maps', () {
    final input = <String, dynamic>{
      'a': '',
      'b': 'value',
      'c': {'d': '', 'e': 'nested'},
      'f': {'g': ''},
    };

    final expected = {
      'b': 'value',
      'c': {'e': 'nested'},
      'f': {},
    };

    final result = HelperUtils.cleanMap(input);
    expect(result, equals(expected));
  });

  test('buildQuery constructs correct expression and params', () {
    final keywords = ['key1', 'key2'];
    final searchableFields = ['field1', 'field2'];
    final otherFilters = ['field3 = "value"'];
    final otherParams = {'paramExtra': 'extra'};

    final (expr, params) = HelperUtils.buildQuery(
      keywords,
      searchableFields,
      otherFilters: otherFilters,
      otherParams: otherParams,
    );

    expect(
      expr,
      equals(
        '(field1 ~ {:param0} || field2 ~ {:param0}) && (field1 ~ {:param1} || field2 ~ {:param1}) && field3 = "value"',
      ),
    );
    expect(params['param0'], equals('key1'));
    expect(params['param1'], equals('key2'));
    expect(params['paramExtra'], equals('extra'));
  });

  test('buildExpansionString joins keys with commas', () {
    expect(
      HelperUtils.buildExpansionString({'a': 'b', 'c': 'd'}),
      equals('a,c'),
    );
    expect(HelperUtils.buildExpansionString({}), isNull);
    expect(HelperUtils.buildExpansionString(null), isNull);
  });

  test('mergeExpansions moves expand field data to top level', () {
    final expansions = {'user_id': 'user'};
    final map = {
      'id': '123',
      'user_id': 'u1',
      'expand': {
        'user_id': {'name': 'John'},
      },
    };

    final result = HelperUtils.mergeExpansions(expansions, map);
    expect(result['user'], equals({'name': 'John'}));
    expect(
      result['expand'],
      equals({
        'user_id': {'name': 'John'},
      }),
    );
  });

  test('getNameFromUrl extracts last segment', () {
    expect(
      HelperUtils.getNameFromUrl('http://localhost/api/files/c/r/file.png'),
      equals('file.png'),
    );
  });

  test('getNamesFromUrls extracts names from multiple urls', () {
    final urls = [
      'http://localhost/file1.png',
      'http://localhost/path/file2.jpg',
    ];
    expect(
      HelperUtils.getNamesFromUrls(urls),
      equals(['file1.png', 'file2.jpg']),
    );
  });

  test('pathsToFiles reads files into Map<String, Uint8List>', () {
    final tempDir = Directory.systemTemp.createTempSync();
    final file1 = File('${tempDir.path}/test1.txt')..writeAsStringSync('hello');
    final file2 = File('${tempDir.path}/test2.txt')..writeAsStringSync('world');

    final result = HelperUtils.pathsToFiles([file1.path, file2.path]);

    expect(result['test1.txt'], equals(Uint8List.fromList('hello'.codeUnits)));
    expect(result['test2.txt'], equals(Uint8List.fromList('world'.codeUnits)));

    tempDir.deleteSync(recursive: true);
  });

  test('buildSortString constructs sort string', () {
    expect(
      HelperUtils.buildSortString(sortField: 'created'),
      equals('+created'),
    );
    expect(
      HelperUtils.buildSortString(sortField: 'created', ascending: false),
      equals('-created'),
    );
    expect(HelperUtils.buildSortString(sortField: null), isNull);
  });
}
