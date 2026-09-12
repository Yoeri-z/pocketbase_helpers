import 'dart:io';

import 'package:pocketbase/pocketbase.dart';
import 'package:yaml/yaml.dart';

/// Name of the config file the CLI falls back to for missing options.
const configFileName = 'pb_generate.yaml';

/// Reads [configFileName] from [workingDirectory], or an empty map when it
/// doesn't exist.
Map<String, dynamic> readConfig(String workingDirectory) {
  final file = File('$workingDirectory/$configFileName');
  if (!file.existsSync()) return {};

  final doc = loadYaml(file.readAsStringSync());
  return doc is YamlMap ? Map<String, dynamic>.from(doc) : {};
}

/// Fetches all collection definitions from the PocketBase API running on
/// localhost at [port].
///
/// Logs in as a superuser with [email] and [password], since the collections
/// API requires superuser auth.
///
/// For safety reasons this always connects to `http://localhost:<port>`:
/// only a port can be specified, never a full URL or hostname.
Future<List<dynamic>> fetchCollections({
  required int port,
  required String email,
  required String password,
}) async {
  final pb = PocketBase('http://localhost:$port');
  await pb.collection('_superusers').authWithPassword(email, password);
  final collections = await pb.collections.getFullList();
  return collections.map((c) => c.toJson()).toList();
}
