import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import '../utils/utils.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late FileHelper<DummyRecord> fileHelper;

  setUp(() {
    (pb, service) = setupRecordMocks();
    fileHelper = FileHelper(
      pocketBaseInstance: pb,
      collection: 'dummy',
      id: 'recordId',
      field: 'fileField',
      mapper: DummyRecord.fromMap,
      expansions: DummyRecord.expansions,
    );
  });

  test('set updates record with single file', () async {
    final (model, expected) = DummyRecord.randomModel();

    mockUpdate(service, model);

    final result = await fileHelper.set('test.png', Uint8List(0));

    expectRecord(result, expected);
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

    mockUpdate(service, model);

    final result = await fileHelper.unset();

    expectRecord(result, expected);
    verify(
      () => service.update(
        'recordId',
        body: {'fileField': null},
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('add updates record with field+ suffix', () async {
    final (model, _) = DummyRecord.randomModel();

    mockUpdate(service, model);

    await fileHelper.add('new.png', Uint8List(0));

    verify(
      () => service.update(
        'recordId',
        files: any(named: 'files'),
        expand: any(named: 'expand'),
      ),
    ).called(1);
  });

  test('addMany updates record with multiple files', () async {
    final (model, _) = DummyRecord.randomModel();

    mockUpdate(service, model);

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
    final (model, _) = DummyRecord.randomModel();

    mockUpdate(service, model);

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
    final (model, _) = DummyRecord.randomModel();

    mockUpdate(service, model);

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
    final (model, _) = DummyRecord.randomModel();

    mockUpdate(service, model);

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
