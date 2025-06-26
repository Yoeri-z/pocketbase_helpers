import 'package:pocketbase_helpers/src/table_models.dart';

///This class contains static helper functions that do not rely on the pocketbase instance
abstract final class HelperUtils {
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
  static String? getSortOrderFor(TableParams params) {
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
}
