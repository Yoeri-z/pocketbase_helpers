import 'package:pocketbase_helpers/src/collection_helper.dart';

///The baseclass for all models that represent a pocketbase record.
///Extend your models with this class to use [CollectionHelper]s
///models should be immutable
abstract interface class PocketBaseRecord {
  const PocketBaseRecord();

  ///The id of this record
  String get id;

  ///A mapper method mapping this object to a map
  ///if your model has a [toJson] method instead, you can implement toMap like this:
  ///```
  ///@override
  ///Map<String, dynamic> toMap() => toJson();
  ///```
  ///
  ///This naming was chosen because the method converts the object into a dart map, so it is more correct.
  Map<String, dynamic> toMap();
}
