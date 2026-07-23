import 'cipher_plugin.dart';

/// Tiene traccia dei cifrari registrati, senza conoscerne le implementazioni
/// concrete. I plugin vengono registrati da
/// lib/bootstrap/plugin_registration.dart.
class CipherRegistry {
  final Map<String, CipherPlugin> _plugins = {};

  void registerAll(Iterable<CipherPlugin> plugins) {
    for (final plugin in plugins) {
      _plugins[plugin.id] = plugin;
    }
  }

  CipherPlugin? byId(String id) => _plugins[id];

  List<CipherPlugin> get all => List.unmodifiable(_plugins.values);
}
