import 'dart:convert';
import 'dart:io';

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers_cli/pocketbase_helpers_cli.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

/// Starts a local HTTP server that mimics the PocketBase superuser password
/// auth endpoint followed by the collections list endpoint.
Future<HttpServer> startFakePocketBase({
  required String email,
  required String password,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((request) async {
    if (request.uri.path == '/api/collections/_superusers/auth-with-password') {
      // Read the full body: it may arrive in multiple TCP chunks.
      final body =
          jsonDecode(await utf8.decoder.bind(request).fold('', (a, b) => a + b))
              as Map;

      if (body['identity'] != email || body['password'] != password) {
        request.response.statusCode = 400;
        request.response.write(
          jsonEncode({'code': 400, 'message': 'Failed to authenticate.'}),
        );
        await request.response.close();
        return;
      }

      final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
      final payload = base64Url
          .encode(utf8.encode(jsonEncode({'exp': exp})))
          .replaceAll('=', '');
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode({
          'token': 'a.$payload.b',
          'record': {'id': 'x'},
        }),
      );
      await request.response.close();
      return;
    }

    request.response.headers.contentType = ContentType.json;
    request.response.write(
      jsonEncode({
        'page': 1,
        'perPage': 500,
        'totalItems': 1,
        'totalPages': 1,
        'items': [
          {
            'id': 'c1',
            'name': 'posts',
            'type': 'base',
            'system': false,
            'fields': [
              {'name': 'title', 'type': 'text', 'required': true},
            ],
          },
        ],
      }),
    );
    await request.response.close();
  });
  return server;
}

void main() {
  group('readConfig', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('pb_generate_test');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('returns an empty map when the config file is missing', () {
      expect(readConfig(tempDir.path), isEmpty);
    });

    test('reads the options from pb_generate.yaml', () {
      File('${tempDir.path}/pb_generate.yaml').writeAsStringSync(
        'source: pb_schema.json\n'
        'port: 8090\n'
        'email: admin@example.com\n'
        'password: hunter2\n'
        'output: lib/models.dart\n',
      );

      final config = readConfig(tempDir.path);

      expect(config, {
        'source': 'pb_schema.json',
        'port': 8090,
        'email': 'admin@example.com',
        'password': 'hunter2',
        'output': 'lib/models.dart',
      });
    });
  });

  group('fetchCollections', () {
    test('logs in and fetches the collections', () async {
      final server = await startFakePocketBase(
        email: 'admin@example.com',
        password: 'hunter2',
      );
      addTearDown(server.close);

      final result = await fetchCollections(
        port: server.port,
        email: 'admin@example.com',
        password: 'hunter2',
      );

      expect(result, hasLength(1));
      expect(result.single['name'], 'posts');
    });

    test('throws on wrong credentials', () async {
      final server = await startFakePocketBase(
        email: 'admin@example.com',
        password: 'hunter2',
      );
      addTearDown(server.close);

      await expectLater(
        fetchCollections(
          port: server.port,
          email: 'admin@example.com',
          password: 'wrong',
        ),
        throwsA(isA<ClientException>()),
      );
    });
  });

  group('CLI end-to-end', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('pb_generate_e2e');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    Future<TestProcess> runCli(List<String> args) {
      // Run the CLI from the real project directory so `dart run` can resolve
      // the package, but with the cwd set to the temp dir so its config and
      // output files live there.
      return TestProcess.start('dart', [
        '${Directory.current.path}/bin/pb_generate.dart',
        ...args,
      ], workingDirectory: tempDir.path);
    }

    test('generates models from the API using the config file', () async {
      final server = await startFakePocketBase(email: 'a@b.c', password: 'p');
      addTearDown(server.close);

      File(
        '${tempDir.path}/pb_generate.yaml',
      ).writeAsStringSync('port: ${server.port}\nemail: a@b.c\npassword: p\n');

      final process = await runCli([]);

      await process.shouldExit(0);
      await expectLater(
        process.stdout,
        emitsThrough(contains('Successfully generated models')),
      );

      expect(
        File('${tempDir.path}/lib/models.dart').readAsStringSync(),
        contains('class Post'),
      );
    });

    test('fails when the api options are incomplete', () async {
      File(
        '${tempDir.path}/pb_generate.yaml',
      ).writeAsStringSync('port: 8090\nemail: a@b.c\n');

      final process = await runCli([]);

      await process.shouldExit(1);
      await expectLater(
        process.stdout,
        emitsThrough(contains('--port, --email and --password')),
      );
    });
  });
}
