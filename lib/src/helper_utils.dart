import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/io_only/export.dart' as io;

///This class contains static helper functions that do not rely on the pocketbase instance
abstract final class HelperUtils {
  ///Register hook to modify the json that gets sent to the pocketbase server instance on creation
  static Map<String, dynamic> Function(
    String collection,
    PocketBase pb,
    Map<String, dynamic> map,
  )
  preCreationHook = (_, _, map) => map;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on updates
  static Map<String, dynamic> Function(
    String collection,
    PocketBase pb,
    Map<String, dynamic> map,
  )
  preUpdateHook = (_, _, map) => map;

  ///Compose an advanced query string with paramaters, to do keyword searching on a collection
  ///This function takes the following fields:
  /// - keywords: the keywords to search for
  /// - fields: the fields on your collection to look for this keyword
  /// - otherFilters: other filters that you want to apply alongside the keyword search
  /// - otherParams: params that are needed by otherFilters if you supplied it
  ///
  ///The function returns a string query and params that can be used to create a filter string using
  ///the filter function on your pocketbase instance:
  ///`pb.filter(query, params)`
  static (String expr, Map<String, dynamic> params) buildQuery(
    ///the keywords to search for
    List<String> keywords,

    ///the fields on your collection to look for this keyword
    List<String> searchableFields, {
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
  }) {
    var termMap = <String, dynamic>{};

    var conditions = <String>[];
    for (final term in keywords) {
      final index = termMap.length;
      termMap['param$index'] = term;
      var subConditions = <String>[];
      for (final field in searchableFields) {
        subConditions.add('$field ~ {:param$index}');
      }
      conditions.add('(${subConditions.join(' || ')})');
    }

    if (otherFilters != null) {
      conditions.addAll(otherFilters);
    }

    if (otherParams != null) {
      termMap.addAll(otherParams);
    }

    return (conditions.join(' && '), termMap);
  }

  ///Pocketbase does returns strings instead of null for fields like:
  /// - Text
  /// - Email
  /// - Url
  /// - DateField
  /// - SelectField if it does not allow multiple selections
  /// - relationfield if it does not allow multiple relations
  ///, most dart serializable packages do support null values
  ///and will even break if you give an empty string for a datetime for example.
  ///This method cleans up a map, making all empty strings null
  static Map<String, dynamic> cleanMap(Map<String, dynamic> map) {
    return map..removeWhere((key, value) {
      if (value is Map<String, dynamic>) {
        map[key] = cleanMap(value);
        return false;
      }
      return (value is String && value.isEmpty);
    });
  }

  static String? buildExpansionString(Map<String, String>? expansions) {
    if (expansions == null || expansions.isEmpty) return null;
    return expansions.keys.join(',');
  }

  ///Merges the expansion field directly into the map, renaming according to [expansions]
  ///For example:
  ///```
  ///{
  ///   "post": "WyAw4bDrvws6gGl",
  ///   "user_id": "FtHAW9feB5rze7D",
  ///   "message": "Example message...",
  ///   "expand": {
  ///       "user_id": {
  ///           "name": "John Doe"
  ///           "username": "users54126",
  ///        }
  ///    }
  ///}
  ///```
  ///will get remapped into:
  ///```
  ///{
  ///   "post": "WyAw4bDrvws6gGl",
  ///   "user_id": "FtHAW9feB5rze7D",
  ///   "user": {
  ///        "name": "John Doe"
  ///        "username": "users54126",
  ///      }
  ///   }
  ///   "message": "Example message...",
  ///}
  ///```
  ///when [expansions] is:
  ///```
  ///{
  ///   "user_id" : "user"
  ///}
  ///```
  static Map<String, dynamic> mergeExpansions(
    Map<String, String>? expansions,
    Map<String, dynamic> map,
  ) {
    if (expansions == null || !map.containsKey('expand')) return map;
    final expandMap = map['expand'] as Map<String, dynamic>;
    for (final entry in expansions.entries) {
      map[entry.value] = expandMap[entry.key];
    }
    return map;
  }

  ///Get the name of a file from their absolute url path, this is simply the last segment of the path
  static String getNameFromUrl(String url) {
    return Uri.parse(url).pathSegments.last;
  }

  ///Gets the names of files from their urls
  static List<String> getNamesFromUrls(List<String> fileUrls) {
    return fileUrls.map(getNameFromUrl).toList();
  }

  ///Convert filepaths into a correctly formatted filemap that is required by the addFiles method
  ///This method does not work for Web and WILL throw an error.
  static Map<String, Uint8List> pathsToFiles(List<String> paths) {
    return io.pathsToFiles(paths);
  }

  ///Build a sort string from a given field and ascending boolean property
  static String? buildSortString({String? sortField, bool ascending = true}) {
    return sortField != null ? '${ascending ? '+' : '-'}$sortField' : null;
  }
}
