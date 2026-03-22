import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

part 'monster_output.dart';

class Json {
  factory Json.fromJson(dynamic value) => throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class JsonNonEmpty {
  factory JsonNonEmpty.fromJson(Map<String, dynamic> value) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class Item {
  factory Item.fromJson(Map<String, dynamic> value) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
