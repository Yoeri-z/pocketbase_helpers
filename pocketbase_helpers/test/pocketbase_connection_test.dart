import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('PocketBaseConnection', () {
    tearDown(() {
      PocketBaseConnection.close();
    });

    test('pb returns default instance if not opened', () {
      final pb = PocketBaseConnection.pb;
      expect(pb.baseURL, equals(PocketBaseConnection.defaultAddress));
    });

    test('open creates new instance with given url', () {
      const url = 'http://example.com';
      PocketBaseConnection.open(url);
      expect(PocketBaseConnection.pb.baseURL, equals(url));
    });

    test('close clears the active instance', () {
      PocketBaseConnection.open('http://example.com');
      PocketBaseConnection.close();
      // Accessing pb again should create a default one
      expect(
        PocketBaseConnection.pb.baseURL,
        equals(PocketBaseConnection.defaultAddress),
      );
    });

    test('setHooks modifies HelperUtils hooks', () {
      Map<String, dynamic> hook(_, _, Map<String, dynamic> m) => m;

      PocketBaseConnection.setHooks(hook, hook);

      expect(HelperUtils.preCreationHook, equals(hook));
      expect(HelperUtils.preUpdateHook, equals(hook));
    });
  });
}
