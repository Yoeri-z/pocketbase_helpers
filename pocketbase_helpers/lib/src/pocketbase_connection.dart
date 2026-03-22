import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/helper_utils.dart';

final class PocketBaseConnection {
  PocketBaseConnection._();

  static final _i = PocketBaseConnection._();

  PocketBase? _activeInstance;

  PocketBase get _pb {
    _activeInstance ??= PocketBase(defaultAddress, reuseHTTPClient: true);

    return _activeInstance!;
  }

  static PocketBase get pb => _i._pb;

  /// Open a new connection to [url], this will close any prior connections
  static void open(String url, {String lang = "en-US", AuthStore? authStore}) {
    if (_i._activeInstance != null) close();
    _i._activeInstance = PocketBase(
      url,
      lang: lang,
      authStore: authStore,
      reuseHTTPClient: true,
    );
  }

  /// Manually set the global pocketbase instance.
  static void setInstance(PocketBase pocketBase) {
    if (_i._activeInstance != null) close();

    _i._activeInstance = pocketBase;
  }

  /// Hooks to modify the raw json maps before they are sent to the server.
  static void setHooks({
    HelperHook? preCreationHook,
    HelperHook? preUpdateHook,
  }) {
    if (preCreationHook != null) HelperUtils.preCreationHook = preCreationHook;
    if (preUpdateHook != null) HelperUtils.preUpdateHook = preUpdateHook;
  }

  /// Check the health of the currently registered pocketbase instance [pb].
  static Future<HealthCheck> health() {
    return pb.health.check();
  }

  /// Close the currently active connection.
  static void close() {
    _i._activeInstance?.close();
    _i._activeInstance = null;
  }

  /// The default address that will be used if the pocketbase connection is never opened manually.
  static const defaultAddress = 'http://localhost:8090';
}
