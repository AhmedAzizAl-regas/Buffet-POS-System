import 'package:buffet_app/core/providers/locale_provider.dart';
import 'package:buffet_app/core/router/router.dart';
import 'package:buffet_app/core/theme/app_theme.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/utils/app_logger.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Start Core Services initialization in the background
  // We do NOT await these here to ensure the app starts instantly.
  await Future.wait([
    AppLogger.init(),
    initializeDateFormatting('ar', ''),
    initializeDateFormatting('en', ''),
    
  ]);

  // 3. Start App immediately
  runApp(const ProviderScope(child: BuffetApp()));
}

class BuffetApp extends ConsumerStatefulWidget {
  const BuffetApp({super.key});

  @override
  ConsumerState<BuffetApp> createState() => _BuffetAppState();
}

class _BuffetAppState extends ConsumerState<BuffetApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 3. Log App Lifecycle to catch when the app goes into background/sleep
    AppLogger.warning("App Lifecycle changed to: ${state.name}");
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // Invalidate the locale provider so it re-checks the system language
    ref.invalidate(localeProvider);
    AppLogger.info(
      "System Locale changed detected. Invalidating localeProvider.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final configs = ref.watch(configProvider);
    final isDark = configs['theme_mode'] == 'dark';

    return MaterialApp.router(
      theme: AppTheme.getTheme(locale, isDark: isDark),
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // 2. Localized Title using the 'S' class
      locale: locale,

      // 3. UPDATED DELEGATES: Using S.delegate
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your custom strings
        GlobalMaterialLocalizations.delegate, // Basic Android UI text
        GlobalWidgetsLocalizations.delegate, // Basic Flutter UI text
        GlobalCupertinoLocalizations.delegate, // Basic iOS UI text
      ],

      // 4. UPDATED SUPPORTED LOCALES
      supportedLocales: AppLocalizations.delegate.supportedLocales,
    );
  }
}
