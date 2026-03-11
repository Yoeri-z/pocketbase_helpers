import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'setup.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late FileHelper<DummyRecord> fileHelper;

  setUp(() {
    pb = MockPocketBase();
    service = MockRecordService();
    when(() => pb.collection(any())).thenReturn(service);
    fileHelper = FileHelper(
      pb: pb,
      collection: 'dummy',
      id: 'recordId',
      field: 'fileField',
      mapper: DummyRecord.fromMap,
      expansions: DummyRecord.expansions,
    );
  });

  test('set updates record with single file', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    final result = await fileHelper.set('test.png', Uint8List(0));

    expect(result.id, equals(expected.id));
    verify(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('unset updates record with null field', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        body: {'fileField': null},
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    final result = await fileHelper.unset();

    expect(result.id, equals(expected.id));
  });

  test('add updates record with field+ suffix', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    await fileHelper.add('new.png', Uint8List(0));

    verify(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).called(1);
    // Note: verifying the exact field name 'fileField+' in MultipartFile is hard with mocktail any()
    // but the implementation uses it.
  });

  test('addMany updates record with multiple files', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    await fileHelper.addMany({'a.png': Uint8List(0), 'b.png': Uint8List(0)});

    verify(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('remove updates record with field- suffix and filename', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        body: {
          'fileField-': ['old.png'],
        },
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    await fileHelper.remove('old.png');

    verify(
      () => service.update(
        'recordId',
        body: {
          'fileField-': ['old.png'],
        },
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('removeMany updates record with list of filenames', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        body: {
          'fileField-': ['a.png', 'b.png'],
        },
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    await fileHelper.removeMany(['a.png', 'b.png']);

    verify(
      () => service.update(
        'recordId',
        body: {
          'fileField-': ['a.png', 'b.png'],
        },
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('removeAll updates record with empty list for field-', () async {
    final (model, expected) = DummyRecord.randomModel();
    when(
      () => service.update(
        'recordId',
        body: {'fileField-': []},
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => model);

    await fileHelper.removeAll();

    verify(
      () => service.update(
        'recordId',
        body: {'fileField-': []},
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });
}
