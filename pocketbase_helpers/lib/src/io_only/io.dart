import 'dart:io';
import 'dart:typed_data';

Map<String, Uint8List> pathsToFiles(List<String> filePaths) {
  final fileMap = <String, Uint8List>{};
  for (final path in filePaths) {
    final file = File(path);
    final name = file.uri.pathSegments.last;
    fileMap[name] = file.readAsBytesSync();
  }

  return fileMap;
}
