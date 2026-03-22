import 'dart:async';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'dummies.dart';

export 'dummies.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockRecordService extends Mock implements RecordService {}

class MockHealthService extends Mock implements HealthService {}

class MockRecordModel extends Mock implements RecordModel {}

(MockPocketBase, MockRecordService) setupRecordMocks() {
  final pb = MockPocketBase();
  final service = MockRecordService();
  when(() => pb.collection(any())).thenReturn(service);
  return (pb, service);
}

(MockPocketBase, MockHealthService) setupHealthMocks() {
  final pb = MockPocketBase();
  final service = MockHealthService();
  when(() => pb.health).thenReturn(service);
  return (pb, service);
}

CollectionHelper<DummyRecord>
createCollectionHelper<T extends PocketBaseRecord>({
  required PocketBase pb,
  Map<String, dynamic> Function(String, PocketBase, Map<String, dynamic>)?
  preCreationHook,
  Map<String, dynamic> Function(String, PocketBase, Map<String, dynamic>)?
  preUpdateHook,
}) {
  return CollectionHelper(
    pocketBaseInstance: pb,
    collection: 'dummy',
    mapper: DummyRecord.fromMap,
    expansions: DummyRecord.expansions,
    preCreationHook: preCreationHook,
    preUpdateHook: preUpdateHook,
  );
}

void mockGetOne(MockRecordService service, RecordModel response) {
  when(
    () => service.getOne(
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockGetList(
  MockRecordService service, {
  required List<RecordModel> items,
  int page = 1,
  int perPage = 30,
  int totalItems = -1,
  int totalPages = -1,
}) {
  final resultList = ResultList(
    items: items,
    page: page,
    perPage: perPage,
    totalItems: totalItems == -1 ? items.length : totalItems,
    totalPages: totalPages == -1 ? 1 : totalPages,
  );

  when(
    () => service.getList(
      page: any(named: 'page'),
      perPage: any(named: 'perPage'),
      expand: any(named: 'expand'),
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => resultList);
}

void mockFullList(MockRecordService service, List<RecordModel> items) {
  when(
    () => service.getFullList(
      batch: any(named: 'batch'),
      expand: any(named: 'expand'),
      sort: any(named: 'sort'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
      filter: any(named: 'filter'),
    ),
  ).thenAnswer((_) async => items);
}

void mockCreate(MockRecordService service, RecordModel response) {
  when(
    () => service.create(
      body: any(named: 'body'),
      files: any(named: 'files'),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockUpdate(MockRecordService service, RecordModel response) {
  when(
    () => service.update(
      any(),
      body: any(named: 'body'),
      files: any(named: 'files'),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockDelete(MockRecordService service) {
  when(
    () => service.delete(
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async {});
}

class MockSubscription {
  void Function(RecordSubscriptionEvent)? callback;
  bool unsubscribed = false;

  void emit(RecordSubscriptionEvent event) {
    callback?.call(event);
  }
}

MockSubscription setupMockSubscription(MockRecordService service) {
  final sub = MockSubscription();

  when(() => service.subscribe(any(), any())).thenAnswer((invocation) {
    sub.callback =
        invocation.positionalArguments[1]
            as void Function(RecordSubscriptionEvent);
    return Future.value(() async {
      sub.unsubscribed = true;
    });
  });

  return sub;
}

void expectRecord(PocketBaseRecord? actual, DummyRecord expected) {
  expect(actual, isNotNull);
  if (actual is DummyRecord) {
    expect(actual.equals(expected), isTrue);
  } else {
    fail('Actual record is not a DummyRecord');
  }
}

void expectRecords(
  List<PocketBaseRecord> actuals,
  List<DummyRecord> expecteds,
) {
  expect(actuals.length, equals(expecteds.length));
  for (var i = 0; i < actuals.length; i++) {
    expectRecord(actuals[i], expecteds[i]);
  }
}
