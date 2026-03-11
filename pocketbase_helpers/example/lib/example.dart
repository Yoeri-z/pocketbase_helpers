import 'package:example/models.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('localhost:8090');

Future<List<User>> fetch() => Users.helper(pb).getFullList();
