import 'package:example/models/generated.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

/// Authenticate John Doe
Future<RecordAuthResult> authenticate() =>
    Users.auth().withPassword('johndoe@gmail.com', 'verysecretpassword');

/// Fetch all the users from the pocketbase api
/// since no connection was specified this will default to http://localhost:8090
Future<List<User>> fetch() => Users.api().getFullList();
