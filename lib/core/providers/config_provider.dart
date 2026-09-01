import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_service.dart';
import 'package:buffet_app/core/utils/app_logger.dart'; // Ensure this import is here

/// Provider to track if the initial database load is complete
final configLoadedProvider = StateProvider<bool>((ref) => false);

class ConfigNotifier extends StateNotifier<Map<String, String>> {
  final Ref _ref;
  final DatabaseService _dbService;

  static const Map<String, String> _defaultSettings = {
    'number_format': 'en',
    'currency_sign': 'assets/icons/sar.svg',
    'date_format': 'dd/MM/yyyy',
    'time_format': 'hh:mm a',
    'tax_percentage': '15',
    'pos_layout': 'grid', // <--- Add this default
    'onboarding_done': 'false',
    'theme_mode': 'light',
  };

  ConfigNotifier(this._ref, this._dbService) : super(_defaultSettings) {
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      AppLogger.debug("Config: Waiting for DatabaseService to initialize...");
      await _dbService.init();
      AppLogger.debug("Config: Loading configurations from database...");
      final db = _dbService.db;
      final List<Map<String, dynamic>> maps = await db.query('configs');

      if (maps.isNotEmpty) {
        final Map<String, String> dbConfigs = {
          for (var item in maps) item['key'] as String: item['value'] as String,
        };

        // Merge defaults with DB values
        state = {..._defaultSettings, ...dbConfigs};
        AppLogger.info(
          "Config: Successfully loaded ${dbConfigs.length} custom settings.",
        );
      } else {
        AppLogger.info("Config: No custom settings found. Using defaults.");
      }
    } catch (e, stack) {
      AppLogger.error("Config: Failed to load configurations", e, stack);
    } finally {
      // Signal that we are done loading (even if it failed with defaults)
      _ref.read(configLoadedProvider.notifier).state = true;
      AppLogger.debug("Config: Initialization complete.");
    }
  }

  Future<void> setConfig(String key, String value) async {
    try {
      final db = _dbService.db;
      await db.insert('configs', {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      state = {...state, key: value};
      AppLogger.info("Config: Updated '$key' to '$value'");
    } catch (e, stack) {
      AppLogger.error("Config: Failed to update setting '$key'", e, stack);
    }
  }

  Future<void> resetConfigs() async {
    try {
      AppLogger.warning("Config: User requested a FACTORY RESET of all settings.");

      // 1. Update the state back to defaults
      state = Map.from(_defaultSettings);

      // 2. Clear from DB (Uncommented and implemented for you)
      final db = _dbService.db;
      await db.delete('configs');

      AppLogger.info("Config: All settings reset to default successfully.");
    } catch (e, stack) {
      AppLogger.error("Config: Failed to reset settings", e, stack);
    }
  }
}

// THE PROVIDER
final configProvider = StateNotifierProvider<ConfigNotifier, Map<String, String>>((ref) {
  final dbService = ref.watch(
    databaseServiceProvider,
  ); // Ensure you have a provider for your DB service
  return ConfigNotifier(ref, dbService);
});
