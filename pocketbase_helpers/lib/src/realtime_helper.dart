import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

/// A helper class that wraps the pocketbase realtime api with some powerfull new features
class RealtimeHelper<T extends Object> {
  /// Instantiate a [RealtimeHelper]
  RealtimeHelper({
    PocketBase? pocketBaseInstance,
    required this.collection,
    required RecordMapper<T> mapper,
    this.debounce,
    this.fields,
    this.expansions,
  }) : _pb = pocketBaseInstance,
       _mapper = mapper;

  final PocketBase? _pb;

  /// The collection this [RealtimeHelper] operates on
  final String collection;

  final RecordMapper<T> _mapper;

  /// If provided, realtime events will be debounced by the provided duration to avoid over requesting.
  final Duration? debounce;

  /// {@macro pocketbase_helpers.helper.expansions}
  final Map<String, String>? expansions;

  /// {@macro pocketbase_helpers.helper.fields}
  final List<String>? fields;

  ///The pocketbase instance used by this helper.
  PocketBase get pb => _pb ?? PocketBaseConnection.pb;

  /// The internal [BaseHelper] helper used by this [RealtimeHelper]
  late final helper = BaseHelper(pocketBaseInstance: pb);

  /// Helper to apply debounce logic to any stream
  Stream<S> _applyDebounce<S>(Stream<S> stream) {
    if (debounce == null) return stream;

    Timer? timer;
    StreamController<S>? controller;
    StreamSubscription<S>? subscription;

    controller = StreamController<S>.broadcast(
      onListen: () {
        subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(debounce!, () {
              if (!controller!.isClosed) controller.add(data);
            });
          },
          onError: controller?.addError,
          onDone: controller?.close,
        );
      },
      onCancel: () {
        timer?.cancel();
        subscription?.cancel();
      },
    );

    return controller.stream;
  }

  /// Get the raw change stream coming from pocketbase.
  Stream<TypedRecordSubscriptionEvent<T>> getChangeStream([String? id]) {
    late StreamController<TypedRecordSubscriptionEvent<T>> controller;
    UnsubscribeFunc? pocketBaseUnsubscribe;

    controller = StreamController<TypedRecordSubscriptionEvent<T>>.broadcast(
      onListen: () async {
        pocketBaseUnsubscribe = await pb.collection(collection).subscribe(
          id ?? '*',
          (e) {
            if (controller.isClosed) return;
            T? parsed;
            if (e.record != null) {
              parsed = _mapper(
                HelperUtils.getRecordJson(e.record!, expansions),
              );
            }
            controller.add(
              TypedRecordSubscriptionEvent(
                action: ChangeAction.fromString(e.action),
                record: parsed,
              ),
            );
          },
        );
      },
      onCancel: () async {
        await pocketBaseUnsubscribe?.call();
        pocketBaseUnsubscribe = null;
        await controller.close();
      },
    );

    return controller.stream;
  }

  /// Get the raw change stream from pocketbase debounced with [debounce].
  ///
  /// if [debounce] is null (the default) this is the same as [getChangeStream].
  Stream<TypedRecordSubscriptionEvent<T>> getDebouncedChangeStream() =>
      _applyDebounce(getChangeStream());

  Stream<T?> watchOne({
    required String id,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    final stream = _applyDebounce(getChangeStream(id));
    return stream.map((event) => event.record);
  }

  Stream<TypedResultList<T>> watchList({
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    bool skipTotal = false,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    final stream = getDebouncedChangeStream();

    return stream.asyncMap(
      (event) => helper.getList(
        collection,
        mapper: _mapper,
        expr: expr,
        params: params,
        page: page,
        perPage: perPage,
        skipTotal: skipTotal,
        sort: sort,
        fields: fields,
        expansions: expansions,
        query: query,
        headers: headers,
      ),
    );
  }

  Stream<List<T>> watchFullList({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    final stream = getDebouncedChangeStream();

    return stream.asyncMap(
      (event) => helper.getFullList(
        collection,
        mapper: _mapper,
        batch: batch,
        expr: expr,
        params: params,
        sort: sort,
        fields: fields,
        expansions: expansions,
        query: query,
        headers: headers,
      ),
    );
  }

  Stream<T?> watchOneOrNull({
    String? expr,
    Map<String, String>? params,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    final stream = getDebouncedChangeStream();

    return stream.asyncMap(
      (event) => helper.getOneOrNull(
        collection,
        mapper: _mapper,
        expr: expr,
        params: params,
        fields: fields,
        expansions: expansions,
        query: query,
        headers: headers,
      ),
    );
  }
}
