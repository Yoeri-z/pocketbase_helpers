import 'dart:io';
import 'dart:typed_data';

Future<Map<String, Uint8List>> pathsToFiles(List<String> filePaths) async {
  final data = await [for (final path in filePaths) pathToFile(path)].wait;

  return {for (final e in data) e.$1: e.$2};
}

Future<(String, Uint8List)> pathToFile(String path) async {
  final file = File(path);
  final name = file.uri.pathSegments.last;
  final bytes = await file.readAsBytes();

  return (name, bytes);
}
