//Note: [CollectionHelper] covers 100% of [BaseHelper]
//so if collection helper is fully tested and works, basehelper does to
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import '../utils/utils.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late CollectionHelper<DummyRecord> helper;

  setUp(() {
    (pb, service) = setupRecordMocks();
    helper = createCollectionHelper(pb: pb);
  });

  test('getList returns mapped result list', () async {
    final items = DummyRecord.manyRandomModels(3);

    mockGetList(service, items: items.map((e) => e.$1).toList(), perPage: 3);

    final result = await helper.getList(page: 1, perPage: 3);

    expectRecords(result.items, items.map((e) => e.$2).toList());
  });

  test('getSingle returns mapped record', () async {
    final (model, expected) = DummyRecord.randomModel();

    mockGetOne(service, model);

    final result = await helper.getOne(expected.id);

    expectRecord(result, expected);
  });

  test('getSingleOrNull returns null for no results', () async {
    mockGetList(service, items: [], perPage: 1);

    final result = await helper.getOneOrNull();
    expect(result, null);
  });

  test('getSingleOrNull returns first record for many results', () async {
    final (model, expected) = DummyRecord.randomModel();

    mockGetList(service, items: [model], perPage: 1);

    final result = await helper.getOneOrNull();

    expect(result, isNotNull);
    expectRecord(result, expected);
  });

  test('update returns updated mapped record', () async {
    final (model, expected) = DummyRecord.randomModel();

    mockUpdate(service, model);

    final result = await helper.update(expected);

    expectRecord(result, expected);
  });

  test('create returns newly created mapped record', () async {
    final (model, expected) = DummyRecord.randomModel();

    mockCreate(service, model);

    final result = await helper.create(data: {});

    expectRecord(result, expected);
  });

  test('delete deletes a record by ID', () async {
    const id = 'test-id';

    mockDelete(service);

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
    final items = DummyRecord.manyRandomModels(2);

    when(() => pb.filter(any(), any())).thenReturn('verified search filter');

    mockGetList(service, items: items.map((e) => e.$1).toList());

    final result = await helper.search(
      keywords: ['key'],
      searchableFields: ['field'],
    );

    expectRecords(result.items, items.map((e) => e.$2).toList());
    verify(() => pb.filter(any(), any())).called(1);
  });

  test('getFullList returns all mapped records', () async {
    final items = DummyRecord.manyRandomModels(5);

    mockFullList(service, items.map((e) => e.$1).toList());

    final result = await helper.getFullList();

    expect(result.length, equals(5));
  });

  test('count returns total items from service', () async {
    mockGetList(service, items: [], totalItems: 42);

    final result = await helper.count();

    expect(result, equals(42));
  });

  test('create calls preCreationHooks and uses outputs in order', () async {
    final (model, _) = DummyRecord.randomModel();
    final inputData = model.toJson();
    final modifiedData = {
      ...inputData,
      'first_modifier': 'transformed',
      'second_modifier': 'done',
    };

    final helperWithHook = createCollectionHelper(
      pb: pb,
      preCreationHook: (col, pb, data) => data..['first_modifier'] = 'done',
    );

    HelperUtils.preCreationHook =
        (col, pb, data) =>
            data
              ..['first_modifier'] = 'transformed'
              ..['second_modifier'] = 'done';

    mockCreate(service, model);

    await helperWithHook.create(data: inputData);

    verify(
      () => service.create(
        body: modifiedData,
        expand: any(named: 'expand'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).called(1);
  });

  test('update calls preUpdateHooks and uses their outputs in order', () async {
    final (model, expected) = DummyRecord.randomModel();
    final modifiedData = {
      ...expected.toMap(),
      'first_modifier': 'transformed',
      'second_modifier': 'done',
    };

    final helperWithHook = createCollectionHelper(
      pb: pb,
      preUpdateHook: (col, pb, data) => data..['first_modifier'] = 'done',
    );

    HelperUtils.preUpdateHook =
        (col, pb, data) =>
            data
              ..['first_modifier'] = 'transformed'
              ..['second_modifier'] = 'done';

    mockUpdate(service, model);

    await helperWithHook.update(expected);

    verify(
      () => service.update(
        expected.id,
        body: modifiedData,
        expand: any(named: 'expand'),
        query: any(named: 'query'),
        headers: any(named: 'headers'),
      ),
    ).called(1);
  });

  test('get multiple constructs expression with all ids', () async {
    final items = DummyRecord.manyRandomModels(3);
    final ids = items.map((e) => e.$2.id).toList();

    when(
      () => pb.filter('id = {:id0} || id = {:id1} || id = {:id2}', {
        'id0': ids[0],
        'id1': ids[1],
        'id2': ids[2],
      }),
    ).thenReturn('verified filter');

    mockFullList(service, items.map((r) => r.$1).toList());

    final results = await helper.getMultiple(ids);

    expectRecords(results, items.map((e) => e.$2).toList());
  });
}
