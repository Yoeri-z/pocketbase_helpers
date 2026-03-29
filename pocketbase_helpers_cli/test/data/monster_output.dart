import "package:pocketbase/pocketbase.dart";
import "package:pocketbase_helpers/pocketbase_helpers.dart";

part "monster_output.g.dart";

class Json {
  const Json();
  factory Json.fromJson(Map<String, dynamic> json) => Json();

  Map<String, dynamic> toJson() => {};
}

class Item {
  const Item();
  factory Item.fromJson(Map<String, dynamic> json) => Item();

  Map<String, dynamic> toJson() => {};
}

class JsonNonEmpty {
  const JsonNonEmpty();
  factory JsonNonEmpty.fromJson(Map<String, dynamic> json) => JsonNonEmpty();

  Map<String, dynamic> toJson() => {};
}
