import 'package:example/example.dart' as example;

void main(List<String> arguments) async {
  print('Retrieving blogs...');
  final blogs = await example.fetch();
  print('Blogs retrieved!');
  print(blogs);
}
