import 'package:example/models/generated.dart';

/// Fetch all the users from the pocketbase api
/// since no connection was specified this will default to http://localhost:8090
Future<List<User>> fetch() => Users.api().getFullList();
