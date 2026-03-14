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
      pocketBaseInstance: pb,
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      expansions: DummyRecord.expansions,
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

    final result = await helper.getOne(actual.id);

    expect(result.equals(actual), isTrue);
  });

  test('getSingleOrNull returns null for no results', () async {
    when(
      () => service.getList(
        page: 1,
        perPage: 1,
        expand: any(named: 'expand'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => ResultList(page: 1));

    final result = await helper.getOneOrNull();
    expect(result, null);
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

  test('search returns mapped result list with filter', () async {
    final items = List.generate(2, (_) => DummyRecord.randomModel());
    final fakeResult = ResultList(
      items: items.map((e) => e.$1).toList(),
      page: 1,
      perPage: 30,
      totalItems: 2,
      totalPages: 1,
    );

    when(() => pb.filter(any(), any())).thenReturn('verified search filter');

    when(
      () => service.getList(
        page: 1,
        perPage: 30,
        filter: 'verified search filter',
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => fakeResult);

    final result = await helper.search(
      keywords: ['key'],
      searchableFields: ['field'],
    );

    expect(result.items.length, equals(2));
    verify(() => pb.filter(any(), any())).called(1);
  });

  test('getFullList returns all mapped records', () async {
    final items = List.generate(5, (_) => DummyRecord.randomModel());

    when(
      () => service.getFullList(batch: 500, expand: any(named: 'expand')),
    ).thenAnswer((_) async => items.map((e) => e.$1).toList());

    final result = await helper.getFullList();

    expect(result.length, equals(5));
  });

  test('count returns total items from service', () async {
    when(
      () => service.getList(page: 1, perPage: 1, filter: any(named: 'filter')),
    ).thenAnswer((_) async => ResultList(totalItems: 42));

    final result = await helper.count();

    expect(result, equals(42));
  });

  test('create calls preCreationHook', () async {
    final (createdModel, expectedRecord) = DummyRecord.randomModel();
    var hookCalled = false;

    final helperWithHook = CollectionHelper(
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      pocketBaseInstance: pb,
      expansions: DummyRecord.expansions,
      preCreationHook: (col, pb, data) {
        hookCalled = true;
        return data;
      },
    );

    when(
      () => service.create(
        body: any(named: 'body'),
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => createdModel);

    await helperWithHook.create(data: {'test': 'data'});

    expect(hookCalled, isTrue);
  });

  test('update calls preUpdateHook', () async {
    final (inputModel, expectedRecord) = DummyRecord.randomModel();
    var hookCalled = false;

    final helperWithHook = CollectionHelper(
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      pocketBaseInstance: pb,
      expansions: DummyRecord.expansions,
      preUpdateHook: (col, pb, data) {
        hookCalled = true;
        return data;
      },
    );

    when(
      () => service.update(
        any(),
        body: any(named: 'body'),
        expand: any(named: 'expand'),
      ),
    ).thenAnswer((_) async => inputModel);

    await helperWithHook.update(expectedRecord);

    expect(hookCalled, isTrue);
  });

  test('get multiple constructs expression with all ids', () async {
    final dummyRecords = List.generate(3, (_) => DummyRecord.randomModel());
    final ids = dummyRecords.map((e) => e.$2.id).toList();

    when(
      () => pb.filter('id = {:id0} || id = {:id1} || id = {:id2}', {
        'id0': ids[0],
        'id1': ids[1],
        'id2': ids[2],
      }),
    ).thenReturn('verified filter');

    when(
      () => service.getFullList(
        filter: 'verified filter',
        expand: any(named: 'expand'),
        sort: any(named: 'sort'),
        headers: any(named: 'headers'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => dummyRecords.map((r) => r.$1).toList());

    final results = await helper.getMultiple(ids);

    for (var (index, result) in results.indexed) {
      expect(result.equals(dummyRecords[index].$2), isTrue);
    }
  });
}
