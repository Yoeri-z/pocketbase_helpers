import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockRecordService extends Mock implements RecordService {}

class MockRecordModel extends Mock implements RecordModel {}

class DummyRecord implements PocketBaseRecord {
  const DummyRecord(this.id, this.data, this.subrecordId, this.subrecord);

  @override
  final String id;
  final String data;
  final String subrecordId;
  final DummySubRecord subrecord;

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'data': data,
    'subrecord_id': subrecordId,
    'subrecord': subrecord.toMap(),
  };

  static DummyRecord fromMap(Map<String, dynamic> map) {
    return DummyRecord(
      map['id'] as String,
      map['data'] as String,
      map['subrecord_id'] as String,
      DummySubRecord.fromMap(map['subrecord'] as Map<String, dynamic>),
    );
  }

  static Map<String, String> get expansions => {'subrecord_id': 'subrecord'};

  static (RecordModel model, DummyRecord actual) randomModel() {
    final subrecordId = faker.guid.guid();
    final subrecordData = faker.lorem.sentence();
    final id = faker.guid.guid();
    final data = faker.lorem.sentence();

    final model = RecordModel.fromJson({
      'id': id,
      'data': data,
      'subrecord_id': subrecordId,
      'expand': {
        'subrecord_id': {'id': subrecordId, 'data': subrecordData},
      },
    });

    final actual = DummyRecord(
      id,
      data,
      subrecordId,
      DummySubRecord(subrecordId, subrecordData),
    );

    return (model, actual);
  }

  bool equals(DummyRecord other) {
    return id == other.id &&
        data == other.data &&
        subrecordId == other.subrecordId &&
        subrecord.id == other.subrecord.id &&
        subrecord.data == other.subrecord.data;
  }
}

class DummySubRecord implements PocketBaseRecord {
  const DummySubRecord(this.id, this.data);

  @override
  final String id;
  final String data;

  @override
  Map<String, dynamic> toMap() => {'id': id, 'data': data};

  static DummySubRecord fromMap(Map<String, dynamic> map) {
    return DummySubRecord(map['id'] as String, map['data'] as String);
  }
}
