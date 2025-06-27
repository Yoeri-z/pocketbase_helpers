//Note: [CollectionHelper] covers 100% of [BaseHelper]
//so if collection helper is fully tested and works, basehelper does to
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'setup.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late CollectionHelper<DummyRecord> helper;

  setUp(() {
    pb = MockPocketBase();
    service = MockRecordService();
    when(() => pb.collection(any())).thenReturn(service);
    helper = CollectionHelper(
      pb,
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      baseExpansions: DummyRecord.expansions,
    );
  });

  test('getList returns mapped result list', () async {
    // Genereer meerdere dummy records
    final items = List.generate(3, (_) {
      final (model, actual) = DummyRecord.randomModel();
      return (model, actual);
    });

    final fakeResult = ResultList(
      items: items.map((e) => e.$1).toList(),
      page: 1,
      perPage: 3,
      totalItems: 3,
      totalPages: 1,
    );

    when(
      () => service.getList(
        page: 1,
        perPage: 3,
        expand: any(named: 'expand'),
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => fakeResult);

    final result = await helper.getList(page: 1, perPage: 3);

    expect(result.items.length, equals(3));

    for (var i = 0; i < 3; i++) {
      expect(result.items[i].equals(items[i].$2), isTrue);
    }
  });

  test('getSingle returns mapped record', () async {
    final (fakeRecord, actual) = DummyRecord.randomModel();

    when(
      () => service.getOne(
        actual.id,
        expand: any(named: 'expand'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((invocation) async => fakeRecord);

    final result = await helper.getSingle(actual.id);

    expect(result.equals(actual), isTrue);
  });

  test('update returns updated mapped record', () async {
    final (inputModel, expectedRecord) = DummyRecord.randomModel();

    when(
      () => service.update(
        inputModel.id,
        body: any(named: 'body'),
        expand: any(named: 'expand'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
        files: any(named: 'files'),
      ),
    ).thenAnswer((_) async => inputModel);

    final result = await helper.update(expectedRecord);

    expect(result.equals(expectedRecord), isTrue);
  });

  test('create returns newly created mapped record', () async {
    final (createdModel, expectedRecord) = DummyRecord.randomModel();

    when(
      () => service.create(
        body: any(named: 'body'),
        expand: any(named: 'expand'),
        files: any(named: 'files'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => createdModel);

    final result = await helper.create(data: {});

    expect(result.equals(expectedRecord), isTrue);
  });

  test('delete deletes a record by ID', () async {
    const id = 'test-id';

    when(
      () => service.delete(
        id,
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async {});

    await helper.delete(id);

    verify(
      () => service.delete(
        id,
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).called(1);
  });
}
