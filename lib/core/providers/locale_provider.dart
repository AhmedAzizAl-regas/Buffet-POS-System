import 'dart:ui';

import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final localeProvider = Provider<Locale>((ref) {
  // 1. Watch the configProvider
  final configs = ref.watch(configProvider);

  // 2. CRITICAL: Check if the database is still empty/loading
  if (configs.isEmpty) {
    return const Locale('en');
  }

  final String? savedLanguage = configs['language'];
  
  // 3. Logic: If no choice yet OR set to 'system', follow the device
  final Locale activeLocale;
  if (savedLanguage == null || savedLanguage == 'system') {
    final String deviceLanguage = PlatformDispatcher.instance.locale.languageCode;
    activeLocale = Locale((deviceLanguage == 'ar') ? 'ar' : 'en');
  } else {
    activeLocale = Locale(savedLanguage);
  }

  // 4. Force global Intl to match so formatters update immediately
  Intl.defaultLocale = activeLocale.languageCode == 'ar' ? 'ar_SA' : 'en_US';

  return activeLocale;
});
