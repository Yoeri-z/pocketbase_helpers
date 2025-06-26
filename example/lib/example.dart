import 'package:example/model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

final pb = PocketBase('localhost:8090');

final helper = CollectionHelper(
  pb,
  collection: 'blogs',
  mapper: BlogRecordMapper.fromMap,
);

Future<List<BlogRecord>> fetch() => helper.getFullList();
