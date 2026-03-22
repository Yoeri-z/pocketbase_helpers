import 'package:example/models/generated.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';

void main(List<String> args) async {
  // Open a connection.
  PocketBaseConnection.open('http://localhost:8090');

  // Set a hook that is used to modify the map before it is sent to the server when creating records
  PocketBaseConnection.setHooks(
    preCreationHook: (collection, pb, map) {
      if (User.isAuthenticated(pb)) {
        map['creator_id'] = User.getAuthenticated(pb);
      }

      return map;
    },
  );

  // Get a strongly typed list of Post
  final posts = await Posts.api().getList(
    expr: 'public = {:public}',
    params: {'public': true},
  );

  print('Found ${posts.totalItems} posts, printing the first ${posts.perPage}');
  for (final post in posts.items) {
    print(post.title);
  }

  // Authenticate
  final result = await Users.auth().withPassword(
    'johndoe@mail.com',
    'supersecretpassword',
  );

  // Return if not authenticated
  if (result.status != AuthStatus.ok) {
    print('Authentication failed for reason ${result.status}');
    PocketBaseConnection.close();
    return;
  }

  // Make a post
  var post = await Posts.api().create(
    data: {
      'title': 'Powering flutter apps with pocketbase!',
      'content': 'This is how you power flutter apps with pocketbase...',
    },
  );

  // Give the post a thumbnail
  // note this will fail in this example since this file doesnt actually exist.
  final (name, data) = await HelperUtils.pathToFile('./images/cute_cat.png');

  post = await Posts.thumbnailApi(post.id).set(name, data);

  // Give the post many attachments
  final files = await HelperUtils.pathsToFiles([
    './attachments/attachments_1.pdf',
    './attachments/attachments_2.pdf',
    './attachments/attachments_3.pdf',
    './attachments/attachments_4.pdf',
  ]);

  post = await Posts.attachmentsApi(post.id).addMany(files);

  PocketBaseConnection.close();
}
