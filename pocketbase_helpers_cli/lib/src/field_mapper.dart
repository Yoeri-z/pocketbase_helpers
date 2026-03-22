import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart';

import 'field.dart';
import 'utils.dart';
import 'generator.dart';

abstract class FieldMapper {
  const FieldMapper(this.field);

  final PocketBaseField field;

  Reference get type;

  Expression mapToField(Expression mapAccess);

  Expression fieldToMap(Expression fieldAccess);

  Reference get copyWithParamType {
    final t = type;
    if (t.symbol == 'dynamic' || t.symbol!.endsWith('?')) {
      return t;
    }
    return refer('${t.symbol}?');
  }

  static FieldMapper forField(
    PocketBaseField field,
    JsonMapBehavior jsonMapBehavior,
  ) {
    return switch (field.type) {
      'autodate' || 'date' => DateFieldMapper(field),
      'number' => NumberFieldMapper(field),
      'bool' => BoolFieldMapper(field),
      'json' => JsonFieldMapper(field, jsonMapBehavior),
      'relation' || 'file' || 'select' => SelectFieldMapper(field),
      'geoPoint' => GeoPointFieldMapper(field),
      _ => DefaultFieldMapper(field),
    };
  }
}

class DefaultFieldMapper extends FieldMapper {
  DefaultFieldMapper(super.field);

  @override
  Reference get type {
    final suffix = field.isDartRequired ? '' : '?';
    return refer(switch (field.type) {
      'text' || 'email' || 'url' || 'editor' || 'password' => 'String$suffix',
      _ => 'dynamic',
    });
  }

  @override
  Expression mapToField(Expression mapAccess) => mapAccess.asA(type);

  @override
  Expression fieldToMap(Expression fieldAccess) => fieldAccess;
}

class DateFieldMapper extends FieldMapper {
  DateFieldMapper(super.field);

  @override
  Reference get type {
    final suffix = field.isDartRequired ? '' : '?';
    return refer('DateTime$suffix');
  }

  @override
  Expression mapToField(Expression mapAccess) {
    final parse = refer(
      'DateTime',
    ).property('parse').call([mapAccess.asA(refer('String'))]);

    if (field.isDartRequired) {
      return parse;
    }

    return mapAccess.notEqualTo(literalNull).conditional(parse, literalNull);
  }

  @override
  Expression fieldToMap(Expression fieldAccess) {
    if (field.isDartRequired) {
      return fieldAccess.property('toIso8601String').call([]);
    }
    return fieldAccess.nullSafeProperty('toIso8601String').call([]);
  }
}

class NumberFieldMapper extends FieldMapper {
  NumberFieldMapper(super.field);

  @override
  Reference get type => refer(field.isInt ? 'int' : 'double');

  @override
  Expression mapToField(Expression mapAccess) {
    return mapAccess
        .asA(refer('num'))
        .property(field.isInt ? 'toInt' : 'toDouble')
        .call([]);
  }

  @override
  Expression fieldToMap(Expression fieldAccess) => fieldAccess;
}

class BoolFieldMapper extends FieldMapper {
  BoolFieldMapper(super.field);

  @override
  Reference get type => refer('bool');

  @override
  Expression mapToField(Expression mapAccess) => mapAccess.asA(refer('bool'));

  @override
  Expression fieldToMap(Expression fieldAccess) => fieldAccess;
}

class SelectFieldMapper extends FieldMapper {
  SelectFieldMapper(super.field);

  @override
  Reference get type {
    if (field.isList) return refer('List<String>');
    final suffix = field.isDartRequired ? '' : '?';
    return refer('String$suffix');
  }

  @override
  Expression mapToField(Expression mapAccess) {
    if (!field.isList) {
      return mapAccess.asA(type);
    }

    final listCast = mapAccess.asA(refer('List<dynamic>'));

    return listCast
        .property('map')
        .call([
          Method(
            (m) => m
              ..requiredParameters.add(Parameter((p) => p..name = 'e'))
              ..lambda = true
              ..body = refer('e').asA(refer('String')).code,
          ).closure,
        ])
        .property('toList')
        .call([]);
  }

  @override
  Expression fieldToMap(Expression fieldAccess) => fieldAccess;
}

class GeoPointFieldMapper extends FieldMapper {
  GeoPointFieldMapper(super.field);

  @override
  Reference get type => refer('GeoPoint');

  @override
  Expression mapToField(Expression mapAccess) {
    return refer('GeoPoint').property('fromMap').call([mapAccess]);
  }

  @override
  Expression fieldToMap(Expression fieldAccess) {
    return fieldAccess.property('toMap').call([]);
  }
}

class JsonFieldMapper extends FieldMapper {
  final JsonMapBehavior behavior;

  JsonFieldMapper(super.field, this.behavior);

  bool get _isPlural => field.name.isPlural;

  String get _className => field.name.singularize().toPascalCase();

  @override
  Reference get type {
    if (behavior == JsonMapBehavior.none) {
      return refer('dynamic');
    }

    final suffix = field.isDartRequired ? '' : '?';
    final typeName = _isPlural ? 'List<$_className>' : _className;
    return refer('$typeName$suffix');
  }

  @override
  Expression mapToField(Expression mapAccess) {
    if (behavior == JsonMapBehavior.none) {
      return mapAccess;
    }

    final methodName = switch (behavior) {
      JsonMapBehavior.fromJson => 'fromJson',
      JsonMapBehavior.fromMap => 'fromMap',
      _ => throw UnimplementedError(),
    };

    if (_isPlural) {
      final castedList = mapAccess.asA(refer('List<dynamic>'));
      final mapExpr = castedList
          .property('map')
          .call([
            Method(
              (m) => m
                ..requiredParameters.add(Parameter((p) => p..name = 'e'))
                ..lambda = true
                ..body = refer(_className).property(methodName).call([
                  refer('e').asA(refer('Map<String, dynamic>')),
                ]).code,
            ).closure,
          ])
          .property('toList')
          .call([]);

      if (field.isDartRequired) {
        return mapExpr;
      }

      return mapAccess
          .notEqualTo(literalNull)
          .conditional(mapExpr, literalNull);
    }

    final call = refer(
      _className,
    ).property(methodName).call([mapAccess.asA(refer('Map<String, dynamic>'))]);

    if (field.isDartRequired) {
      return call;
    }

    return mapAccess.notEqualTo(literalNull).conditional(call, literalNull);
  }

  @override
  Expression fieldToMap(Expression fieldAccess) {
    if (behavior == JsonMapBehavior.none) {
      return fieldAccess;
    }

    final methodName = switch (behavior) {
      JsonMapBehavior.fromJson => 'toJson',
      JsonMapBehavior.fromMap => 'toMap',
      _ => throw UnimplementedError(),
    };

    if (_isPlural) {
      final mapClosure = Method(
        (m) => m
          ..requiredParameters.add(Parameter((p) => p..name = 'e'))
          ..lambda = true
          ..body = refer('e').property(methodName).call([]).code,
      ).closure;

      if (field.isDartRequired) {
        return fieldAccess
            .property('map')
            .call([mapClosure])
            .property('toList')
            .call([]);
      }

      return fieldAccess
          .nullSafeProperty('map')
          .call([mapClosure])
          .property('toList')
          .call([]);
    }

    if (field.isDartRequired) {
      return fieldAccess.property(methodName).call([]);
    }

    return fieldAccess.nullSafeProperty(methodName).call([]);
  }
}
