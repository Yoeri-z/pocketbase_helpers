import 'dart:typed_data';

import './shared.dart';
import './base_helper.dart';

abstract class MockHandler {
  const MockHandler();

  String get collection;

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
  });

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
  });

  Future<List<T>> onGetFullList<T extends Object>({
    int batch = 500,
    String? expr,
    Map<String, dynamic>? params,
    String? sort,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<T> onGetOne<T extends Object>({
    required String id,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<List<T>> onGetMultiple<T extends Object>({
    required Iterable<String> ids,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool iterative = false,
  });

  Future<T?> onGetOneOrNull<T extends Object>({
    String? expr,
    Map<String, dynamic>? params,
    List<String>? fields,
    Map<String, String>? expansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<int> onCount({
    String? expr,
    Map<String, dynamic>? params,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<T> onCreate<T extends Object>({
    required Map<String, dynamic> data,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<T> onUpdate<T extends Object>({
    required String id,
    required Map<String, dynamic> body,
    Map<String, String>? expansions,
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  Future<void> onDelete({
    required String id,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  MockFileHelper<T> onFileField<T extends PocketBaseRecord>({
    required String id,
    required String field,
    Map<String, String>? expansions,
  });
}

abstract class MockFileHelper<T extends Object> implements FileHelper<T> {
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
