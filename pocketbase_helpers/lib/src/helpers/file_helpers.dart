import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../shared.dart';
import '../helper_utils.dart';
import '../pocketbase_connection.dart';

/// Interface to interact with single file fields
abstract interface class SingleFileHelper<T extends Object> {
  ///Set a single file in the field.
  Future<T> set(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  ///Sets the file field to be empty.
  ///
  ///Only works on fields that do not support multiple files.
  ///If you want to clear all files on a multi file field, use [removeAll] instead.
  Future<T> unset({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });
}

/// Interface to interact with multi file fields
abstract interface class MultiFileHelper<T extends Object> {
  ///Add a file to the field, only works if the field supports multiple files.
  Future<T> add(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  ///Add multiple files to the field, only works if the fieldSupports multiple files.
  Future<T> addMany(
    Map<String, Uint8List> files, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  ///Remove a file from the field, only works if the field supports multiple files.
  Future<T> remove(
    String fileName, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  ///Remove multiple files from the field, only works if the field supports multiple files.
  Future<T> removeMany(
    List<String> names, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });

  ///Remove multiple files from the field, only works if the field supports multiple files.
  ///
  ///If you want to remove the file from a single file field use [unset] instead.
  Future<T> removeAll({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  });
}

///A helper to do operations on a single file field.
class FileHelper<T extends Object>
    implements SingleFileHelper<T>, MultiFileHelper<T> {
  ///A helper to do operations on a single file field.
  const FileHelper({
    PocketBase? pocketBaseInstance,
    required this.collection,
    required this.id,
    required this.field,
    required RecordMapper<T> mapper,
    Map<String, String>? expansions,
  }) : _pb = pocketBaseInstance,
       _mapper = mapper,
       _expansions = expansions;

  final PocketBase? _pb;
  PocketBase get pb => _pb ?? PocketBaseConnection.pb;

  final RecordMapper<T> _mapper;
  final Map<String, String>? _expansions;

  ///The collection this helper is operating on.
  final String collection;

  ///The id of the record this helper is operating on.
  final String id;

  ///The file field this helper is operating on
  final String field;

  @override
  Future<T> set(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          files: [
            http.MultipartFile.fromBytes(field, fileData, filename: fileName),
          ],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> unset({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: {field: null},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> add(
    String fileName,
    Uint8List fileData, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          files: [
            http.MultipartFile.fromBytes(
              '$field+',
              fileData,
              filename: fileName,
            ),
          ],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> addMany(
    Map<String, Uint8List> files, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          files: [
            for (final entry in files.entries)
              http.MultipartFile.fromBytes(
                '$field+',
                entry.value,
                filename: entry.key,
              ),
          ],
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> remove(
    String fileName, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: {
            '$field-': [fileName],
          },
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> removeMany(
    List<String> names, {
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: {'$field-': names},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }

  @override
  Future<T> removeAll({
    List<String>? fields,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final record = await pb
        .collection(collection)
        .update(
          id,
          body: {'$field-': []},
          fields: fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(record, _expansions));
  }
}
