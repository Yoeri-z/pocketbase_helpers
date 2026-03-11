import 'package:example/example.dart' as example;

void main(List<String> arguments) async {
  print('Retrieving users...');
  final users = await example.fetch();
  print('Users retrieved!');
  print(users);
}
