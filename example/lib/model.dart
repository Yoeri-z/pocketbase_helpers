import 'package:dart_mappable/dart_mappable.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

part 'model.mapper.dart';

@MappableClass()
class BlogRecord with BlogRecordMappable implements PocketBaseRecord {
  @override
  final String id;
  final String authorName;
  final String title;
  final String content;
  final DateTime created;
  final DateTime? updated;

  BlogRecord({
    required this.id,
    required this.authorName,
    required this.title,
    required this.content,
    required this.created,
    required this.updated,
  });
}
