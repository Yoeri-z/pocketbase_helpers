import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import '../utils/utils.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late RealtimeHelper<DummyRecord> helper;

  setUp(() {
    (pb, service) = setupRecordMocks();
    helper = RealtimeHelper(
      pocketBaseInstance: pb,
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      expansions: DummyRecord.expansions,
    );
  });

  group('getChangeStream', () {
    test('subscribes to correct collection and emits mapped events', () async {
      final (model, expected) = DummyRecord.randomModel();
      final sub = setupMockSubscription(service);

      final stream = helper.getChangeStream();

      // We need to listen to trigger onListen
      final expectFuture = expectLater(
        stream,
        emits(
          predicate<TypedRecordSubscriptionEvent<DummyRecord>>((event) {
            return event.action == ChangeAction.create &&
                event.record != null &&
                event.record!.equals(expected);
          }),
        ),
      );

      await Future.delayed(Duration.zero);

      sub.emit(RecordSubscriptionEvent(action: 'create', record: model));

      await expectFuture;
      verify(() => service.subscribe('*', any())).called(1);
    });

    test('unsubscribes when listener is cancelled', () async {
      final sub = setupMockSubscription(service);

      final subscription = helper.getChangeStream().listen((_) {});
      await Future.delayed(Duration.zero);
      await subscription.cancel();

      expect(sub.unsubscribed, isTrue);
    });

    test('subscribes with specific ID if provided', () async {
      setupMockSubscription(service);

      final stream = helper.getChangeStream('test-id');
      final subscription = stream.listen((_) {});
      await Future.delayed(Duration.zero);

      verify(() => service.subscribe('test-id', any())).called(1);
      await subscription.cancel();
    });
  });

  group('debounce', () {
    test('debounces events correctly', () async {
      final debouncedHelper = RealtimeHelper(
        pocketBaseInstance: pb,
        collection: 'dummy',
        mapper: DummyRecord.fromMap,
        debounce: const Duration(milliseconds: 50),
        expansions: DummyRecord.expansions,
      );

      final sub = setupMockSubscription(service);

      final stream = debouncedHelper.getDebouncedChangeStream();
      final events = <TypedRecordSubscriptionEvent<DummyRecord>>[];
      final subscription = stream.listen(events.add);

      await Future.delayed(Duration.zero);

      final (model1, _) = DummyRecord.randomModel();
      final (model2, _) = DummyRecord.randomModel();

      sub.emit(RecordSubscriptionEvent(action: 'update', record: model1));
      sub.emit(RecordSubscriptionEvent(action: 'update', record: model2));

      // After 30ms, no event should have been emitted yet
      await Future.delayed(const Duration(milliseconds: 30));
      expect(events, isEmpty);

      // After another 30ms , the last event should be emitted
      await Future.delayed(const Duration(milliseconds: 30));
      expect(events.length, equals(1));
      expect(events.first.record!.id, equals(model2.id));

      await subscription.cancel();
    });
  });

  group('watchOne', () {
    test('emits record updates', () async {
      final (model, expected) = DummyRecord.randomModel();
      final sub = setupMockSubscription(service);

      final stream = helper.watchOne(id: expected.id);

      final expectFuture = expectLater(
        stream,
        emits(predicate<DummyRecord?>((record) => record!.equals(expected))),
      );

      await Future.delayed(Duration.zero);
      sub.emit(RecordSubscriptionEvent(action: 'update', record: model));

      await expectFuture;
      verify(() => service.subscribe(expected.id, any())).called(1);
    });
  });

  group('watchList', () {
    test('triggers re-fetch on any collection change', () async {
      final sub = setupMockSubscription(service);

      final items = List.generate(1, (_) => DummyRecord.randomModel());

      mockGetList(service, items: [items[0].$1]);

      final stream = helper.watchList();
      final events = <TypedResultList<DummyRecord>>[];
      final subscription = stream.listen(events.add);

      await Future.delayed(Duration.zero);

      // Trigger a change
      sub.emit(RecordSubscriptionEvent(action: 'create', record: items[0].$1));

      // wait for asyncMap to complete
      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expectRecords(events.first.items, [items[0].$2]);

      verify(
        () =>
            service.getList(page: 1, perPage: 30, expand: any(named: 'expand')),
      ).called(1);

      await subscription.cancel();
    });
  });

  group('watchFullList', () {
    test('triggers re-fetch on any collection change', () async {
      final sub = setupMockSubscription(service);

      final items = List.generate(2, (_) => DummyRecord.randomModel());

      mockFullList(service, items.map((e) => e.$1).toList());

      final stream = helper.watchFullList();
      final events = <List<DummyRecord>>[];
      final subscription = stream.listen(events.add);

      await Future.delayed(Duration.zero);

      sub.emit(RecordSubscriptionEvent(action: 'update', record: items[0].$1));

      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first.length, equals(2));

      verify(
        () => service.getFullList(batch: 500, expand: any(named: 'expand')),
      ).called(1);

      await subscription.cancel();
    });
  });

  group('watchOneOrNull', () {
    test('triggers re-fetch on any collection change', () async {
      final sub = setupMockSubscription(service);

      final (model, expected) = DummyRecord.randomModel();

      mockGetList(service, items: [model], perPage: 1);

      final stream = helper.watchOneOrNull();
      final events = <DummyRecord?>[];
      final subscription = stream.listen(events.add);

      await Future.delayed(Duration.zero);

      sub.emit(RecordSubscriptionEvent(action: 'delete', record: model));

      await Future.delayed(const Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expectRecord(events.first, expected);

      verify(
        () =>
            service.getList(page: 1, perPage: 1, expand: any(named: 'expand')),
      ).called(1);

      await subscription.cancel();
    });
  });
}
