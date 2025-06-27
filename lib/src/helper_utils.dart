import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/models.dart';

///This class contains static helper functions that do not rely on the pocketbase instance
abstract final class HelperUtils {
  ///Register hook to modify the json that gets sent to the pocketbase server instance on creation
  static Map<String, dynamic> Function(
    String collection,
    PocketBase pb,
    Map<String, dynamic> map,
  )
  creationHook = (_, _, map) => map;

  ///Register hook to modify the json that gets sent to the pocketbase server instance on updates
  static Map<String, dynamic> Function(
    String collection,
    PocketBase pb,
    Map<String, dynamic> map,
  )
  updateHook = (_, _, map) => map;

  ///Compose an advanced query string with paramaters, to do keyword searching on a collection
  ///This function takes the following fields:
  /// - query: the keywords to search for, will be comma seperated
  /// - fields: the fields on your collection to look for this keyword
  /// - otherFilters: other filters that you want to apply alongside the keyword search
  /// - otherParams: params that are needed by otherFilters if you supplied it
  ///
  ///The function returns a string query and params that can be used to create a filter string using
  ///the filter function on your pocketbase instance:
  ///`pb.filter(query, params)`
  static (String query, Map<String, dynamic> params) buildQuery(
    ///the keywords to search for, will be comma seperated
    String query,

    ///the fields on your collection to look for this keyword
    List<String> fields, {
    List<String>? otherFilters,
    Map<String, dynamic>? otherParams,
  }) {
    final terms = query.split(',').map((str) => str.trim());
    var termMap = <String, dynamic>{};

    var conditions = <String>[];
    for (final term in terms) {
      final index = termMap.length;
      termMap['param$index'] = term;
      var subConditions = <String>[];
      for (final field in fields) {
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

  ///Get a sort order appropiately formatted to be put into the `sort` field on pocketbase queries
  static String? getSortOrderFor(SearchParams params) {
    return params.sortColumn != null
        ? '${params.ascending ? '+' : '-'}${params.sortColumn}'
        : null;
  }

  ///Pocketbase does not return null values, but most dart serializable packages do support null values.
  ///This method cleans up a map, making all empty values null
  static Map<String, dynamic> cleanMap(Map<String, dynamic> map) {
    return map..removeWhere(
      (_, value) => (value is String && value.isEmpty) || value == const {},
    );
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
  static Map<String, dynamic> mergeExpansion(
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

  ///Gets the names of files from their urls, this is simply the last path segment
  List<String> getNamesFromUrls(List<String> fileUrls) {
    return fileUrls.map((f) => Uri.parse(f).pathSegments.last).toList();
  }
}
