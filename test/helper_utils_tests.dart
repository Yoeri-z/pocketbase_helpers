import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

void main() {
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
}
