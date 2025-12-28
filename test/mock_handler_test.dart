import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'setup.dart';

class MockMockHandler extends Mock implements MockHandler {}

class MockMockFileHelper extends Mock implements MockFileHelper<DummyRecord> {}

void main() {
  late MockPocketBase pb;
  late BaseHelper helper;
  late MockMockHandler mockHandler;
  late MockRecordService service;

  setUp(() {
    pb = MockPocketBase();
    service = MockRecordService();
    helper = BaseHelper(pb);
    mockHandler = MockMockHandler();
    when(() => mockHandler.collection).thenReturn('dummy');
    when(() => pb.collection(any())).thenReturn(service);
    HelperUtils.addHandlers([mockHandler]);
    HelperUtils.fallbackWhenTesting = false;
  });

  tearDown(() {
    HelperUtils.clearHandlers();
  });

  group('BaseHelper with MockHandler', () {
    test('search calls onSearch on handler', () async {
      final resultList = TypedResultList<DummyRecord>(
        [],
        totalItems: 0,
        totalPages: 1,
        page: 1,
        perPage: 30,
      );
      when(
        () => mockHandler.onSearch<DummyRecord>(
          keywords: any(named: 'keywords'),
          searchableFields: any(named: 'searchableFields'),
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
          sort: any(named: 'sort'),
          additionalExpressions: any(named: 'additionalExpressions'),
          additionalParams: any(named: 'additionalParams'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => resultList);

      await helper.search<DummyRecord>(
        'dummy',
        keywords: ['test'],
        searchableFields: ['field'],
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onSearch<DummyRecord>(
          keywords: ['test'],
          searchableFields: ['field'],
          page: 1,
          perPage: 30,
          sort: null,
          additionalExpressions: null,
          additionalParams: null,
          fields: null,
          expansions: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('getList calls onGetList on handler', () async {
      final resultList = TypedResultList<DummyRecord>(
        [],
        totalItems: 0,
        totalPages: 1,
        page: 1,
        perPage: 30,
      );
      when(
        () => mockHandler.onGetList<DummyRecord>(
          expr: any(named: 'expr'),
          params: any(named: 'params'),
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
          sort: any(named: 'sort'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => resultList);

      await helper.getList<DummyRecord>('dummy', mapper: DummyRecord.fromMap);

      verify(
        () => mockHandler.onGetList<DummyRecord>(
          expr: null,
          params: null,
          page: 1,
          perPage: 30,
          sort: null,
          fields: null,
          expansions: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('getFullList calls onGetFullList on handler', () async {
      when(
        () => mockHandler.onGetFullList<DummyRecord>(
          batch: any(named: 'batch'),
          expr: any(named: 'expr'),
          params: any(named: 'params'),
          sort: any(named: 'sort'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => []);

      await helper.getFullList<DummyRecord>(
        'dummy',
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onGetFullList<DummyRecord>(
          batch: 500,
          expr: null,
          params: null,
          sort: null,
          fields: null,
          expansions: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('getOne calls onGetOne on handler', () async {
      final (_, record) = DummyRecord.randomModel();
      when(
        () => mockHandler.onGetOne<DummyRecord>(
          id: any(named: 'id'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => record);

      final result = await helper.getOne<DummyRecord>(
        'dummy',
        id: record.id,
        mapper: DummyRecord.fromMap,
      );

      expect(result.equals(record), isTrue);
      verify(
        () => mockHandler.onGetOne<DummyRecord>(
          id: record.id,
          fields: null,
          expansions: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('getMultiple calls onGetMultiple on handler', () async {
      when(
        () => mockHandler.onGetMultiple<DummyRecord>(
          ids: any(named: 'ids'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
          iterative: any(named: 'iterative'),
        ),
      ).thenAnswer((_) async => []);

      await helper.getMultiple<DummyRecord>(
        'dummy',
        ids: ['1', '2'],
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onGetMultiple<DummyRecord>(
          ids: ['1', '2'],
          fields: null,
          expansions: null,
          query: null,
          headers: null,
          iterative: false,
        ),
      ).called(1);
    });

    test('getOneOrNull calls onGetOneOrNull on handler', () async {
      when(
        () => mockHandler.onGetOneOrNull<DummyRecord>(
          expr: any(named: 'expr'),
          params: any(named: 'params'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => null);

      await helper.getOneOrNull<DummyRecord>(
        'dummy',
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onGetOneOrNull<DummyRecord>(
          expr: null,
          params: null,
          fields: null,
          expansions: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('count calls onCount on handler', () async {
      when(
        () => mockHandler.onCount(
          expr: any(named: 'expr'),
          params: any(named: 'params'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => 5);

      final result = await helper.count('dummy');

      expect(result, 5);
      verify(
        () => mockHandler.onCount(
          expr: null,
          params: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('create calls onCreate on handler', () async {
      final (_, record) = DummyRecord.randomModel();
      final data = {'data': faker.lorem.sentence()};
      when(
        () => mockHandler.onCreate<DummyRecord>(
          data: any(named: 'data'),
          expansions: any(named: 'expansions'),
          fields: any(named: 'fields'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => record);

      await helper.create<DummyRecord>(
        'dummy',
        data: data,
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onCreate<DummyRecord>(
          data: data,
          expansions: null,
          fields: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('update calls onUpdate on handler', () async {
      final (_, record) = DummyRecord.randomModel();
      final body = {'data': faker.lorem.sentence()};
      when(
        () => mockHandler.onUpdate<DummyRecord>(
          id: any(named: 'id'),
          body: any(named: 'body'),
          expansions: any(named: 'expansions'),
          fields: any(named: 'fields'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => record);

      await helper.update<DummyRecord>(
        'dummy',
        id: record.id,
        body: body,
        mapper: DummyRecord.fromMap,
      );

      verify(
        () => mockHandler.onUpdate<DummyRecord>(
          id: record.id,
          body: body,
          expansions: null,
          fields: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('delete calls onDelete on handler', () async {
      const id = '123';
      when(
        () => mockHandler.onDelete(
          id: any(named: 'id'),
          body: any(named: 'body'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {});

      await helper.delete('dummy', id: id);

      verify(
        () => mockHandler.onDelete(
          id: id,
          body: null,
          query: null,
          headers: null,
        ),
      ).called(1);
    });

    test('throws exception when no handler is found', () async {
      expect(
        () async => await helper.getOne<DummyRecord>(
          'unmocked_collection',
          id: '123',
          mapper: DummyRecord.fromMap,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: No mock handler found for collection "unmocked_collection" during testing.',
          ),
        ),
      );
    });

    test('falls back to pb when fallbackWhenTesting is true', () async {
      HelperUtils.fallbackWhenTesting = true;
      final (model, _) = DummyRecord.randomModel();
      when(
        () => service.getOne(
          any(),
          expand: any(named: 'expand'),
          fields: any(named: 'fields'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => model);

      await helper.getOne<DummyRecord>(
        'unmocked_collection',
        id: '123',
        mapper: DummyRecord.fromMap,
        expansions: DummyRecord.expansions,
      );

      verify(
        () => service.getOne(
          '123',
          expand: any(named: 'expand'),
          fields: any(named: 'fields'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).called(1);
      verifyNever(
        () => mockHandler.onGetOne<DummyRecord>(
          id: any(named: 'id'),
          fields: any(named: 'fields'),
          expansions: any(named: 'expansions'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      );
    });
  });
}
