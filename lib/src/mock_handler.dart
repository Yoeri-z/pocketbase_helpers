import 'dart:typed_data';

import './shared.dart';
import './base_helper.dart';

/// A [MockHandler] is a handler that can intercept and handle pocketbase calls.
///
/// To activate handlers call: `HelperUtils.addHandlers([...myHandlers])]`
abstract class MockHandler {
  /// Construct a Mocked Handler
  const MockHandler();

  /// The collection this handler is setup for.
  String get collection;

  /// handler method that is called when search is called on a helper with [collection].
  Future<TypedResultList<T>> onSearch<T extends Object>({
    required List<String> keywords,
    required List<String> searchableFields,
    int page = 1,
    int perPage = 30,
    String? sort,
    List<String>? additionalExpressions,
    Map<String, dynamic>? additionalParams,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `getList` is called on a helper with [collection].
  Future<TypedResultList<T>> onGetList<T extends Object>({
    String? expr,
    Map<String, dynamic>? params,
    int page = 1,
    int perPage = 30,
    String? sort,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `getFullList` is called on a helper with [collection].
  Future<List<T>> onGetFullList<T extends Object>({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `getOne` is called on a helper with [collection].
  Future<T> onGetOne<T extends Object>({
    required String id,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `getMultiple` is called on a helper with [collection].
  Future<List<T>> onGetMultiple<T extends Object>({
    required Iterable<String> ids,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool iterative = false,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `getOneOrNull` is called on a helper with [collection].
  Future<T?> onGetOneOrNull<T extends Object>({
    String? expr,
    Map<String, dynamic>? params,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `count` is called on a helper with [collection].
  Future<int> onCount({
    String? expr,
    Map<String, dynamic>? params,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `create` is called on a helper with [collection].
  Future<T> onCreate<T extends Object>({
    required Map<String, dynamic> data,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `update` is called on a helper with [collection].
  Future<T> onUpdate<T extends Object>({
    required String id,
    required Map<String, dynamic> body,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `delete` is called on a helper with [collection].
  Future<void> onDelete({
    required String id,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    throw UnimplementedError();
  }

  /// handler method that is called when `fileField` is called on a helper with [collection].
  MockFileHelper<T> onFileField<T extends PocketBaseRecord>({
    required String id,
    required String field,
    Map<String, String>? expansions,
  }) {
    throw UnimplementedError();
  }
}

/// An abstract class that can be extended to mock FileHelpers.
abstract class MockFileHelper<T extends Object> implements FileHelper<T> {
  /// Construct a mock FileHelper
  const MockFileHelper({
    required this.collection,
    required this.id,
    required this.field,
  });

  @override
  final String collection;
  @override
  final String id;
  @override
  final String field;

  @override
  Future<T> set(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  @override
  Future<T> unset({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  @override
  Future<T> add(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  @override
  Future<T> addMany(
    Map<String, Uint8List> files, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  @override
  Future<T> remove(
    String fileName, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  @override
  Future<T> removeMany(
    List<String> names, {
    List<String>? fields,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  });

  @override
  Future<T> removeAll({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });
}
