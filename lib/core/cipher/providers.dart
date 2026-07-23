import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap/plugin_registration.dart';
import 'cipher_config.dart';
import 'cipher_plugin.dart';
import 'cipher_registry.dart';

final cipherRegistryProvider = Provider<CipherRegistry>((ref) {
  final registry = CipherRegistry();
  registry.registerAll(buildRegisteredPlugins());
  return registry;
});

final selectedCipherIdProvider = StateProvider<String>((ref) {
  return ref.watch(cipherRegistryProvider).all.first.id;
});

final selectedCipherProvider = Provider<CipherPlugin>((ref) {
  final registry = ref.watch(cipherRegistryProvider);
  final id = ref.watch(selectedCipherIdProvider);
  return registry.byId(id)!;
});

class CipherConfigNotifier extends StateNotifier<CipherConfig> {
  CipherConfigNotifier(this._ref)
    : super(_ref.read(selectedCipherProvider).defaultConfig) {
    _ref.listen<CipherPlugin>(selectedCipherProvider, (previous, next) {
      state = next.defaultConfig;
    });
  }

  final Ref _ref;

  void update(CipherConfig config) => state = config;
}

/// Config del cifrario correntemente selezionato; si resetta al proprio
/// defaultConfig ogni volta che cambia il cifrario selezionato.
final cipherConfigProvider =
    StateNotifierProvider<CipherConfigNotifier, CipherConfig>((ref) {
      return CipherConfigNotifier(ref);
    });
