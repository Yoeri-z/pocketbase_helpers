import 'package:example/models/generated.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('localhost:8090');

Future<List<User>> fetch() => Users.helper(pb).getFullList();
