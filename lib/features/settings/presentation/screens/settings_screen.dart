import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/core/constants/app_strings.dart';
import 'package:buffet_app/core/constants/countries.dart';
import 'package:buffet_app/core/providers/common_providers.dart';
import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/database_io_helper.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:buffet_app/core/utils/nav_helper.dart';
import 'package:buffet_app/core/utils/permission_helper.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:buffet_app/features/auth/data/auth_database_service.dart';
import 'package:buffet_app/features/auth/presentation/providers/auth_notifiers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _localTapCount = 0;
  DateTime? _lastTapTime;
  bool _isAuthenticating = false;
  @override
  Widget build(BuildContext context) {
    final versionAsync = ref.watch(appVersionProvider);

    // Watch the entire config map
    final configs = ref.watch(configProvider);

    // Get the buffet name with a fallback
    final buffetName =
        configs['business_name'] ?? AppLocalizations.of(context).bestBuffet;
    final currentLang = configs['language'] ?? 'system';
    final String langDisplay;
    if (currentLang == 'system') {
      langDisplay = AppLocalizations.of(context).systemDefault;
    } else if (currentLang == 'ar') {
      langDisplay = "العربية";
    } else {
      langDisplay = "English";
    }
    final themeMode = configs['theme_mode'] ?? 'light';
    final String themeDisplay;
    if (themeMode == 'dark') {
      themeDisplay = AppLocalizations.of(context).darkMode;
    } else {
      themeDisplay = AppLocalizations.of(context).lightMode;
    }
    final currencySign = configs['currency_sign'] ?? 'YR';
    final numFormat = configs['number_format'] ?? 'en'; // 'en' or 'ar'

    final dateFormat = configs['date_format'] ?? 'dd/MM/yyyy';

    return Scaffold(
      appBar: AppBar(
        title: NavHelper.buildNavTitle(
          context,
          title: Text(AppLocalizations.of(context).settings),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(AppLocalizations.of(context).businessInfo),
          _buildSettingCard(
            icon: Icons.store_rounded,
            title: AppLocalizations.of(context).buffetName,
            subtitle: buffetName,
            onTap: () => _showEditNameDialog(context, ref, buffetName),
          ),

          // ── Account Information Section ──
          const SizedBox(height: 24),
          _buildAccountSection(context, ref),

          const SizedBox(height: 24),
          // --- NEW LOCALIZATION SECTION ---
          _buildSectionTitle(AppLocalizations.of(context).localization),
          _buildSettingCard(
            icon: Icons.language_rounded,
            title: AppLocalizations.of(context).appLanguage,
            subtitle: langDisplay,
            onTap: () => _showLanguageDialog(context, ref, currentLang),
          ),
          _buildSettingCard(
            icon: themeMode == 'dark' ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: AppLocalizations.of(context).themeMode,
            subtitle: themeDisplay,
            onTap: () => _showThemeDialog(context, ref, themeMode),
          ),
          _buildSettingCard(
            icon: Icons.numbers_rounded,
            title: AppLocalizations.of(
              context,
            ).numbersFormat, // Ensure this is in .arb
            subtitle: numFormat == 'ar' ? "١٢٣" : "123",
            onTap: () => _showNumberFormatDialog(context, ref, numFormat),
          ),
          _buildSettingCard(
            icon: Icons.paid_rounded,
            title: AppLocalizations.of(context).currencySign,
            subtitle: currencySign.contains('.svg')
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        currencySign,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          Colors.grey.shade600,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  )
                : currencySign, //
            onTap: () => _showCurrencySignDialog(context, ref, currencySign),
          ),
          _buildSettingCard(
            icon: Icons.calendar_month_rounded,
            title: AppLocalizations.of(context).dateFormat,
            subtitle: DateTime.now().toLocalDate(ref),
            onTap: () => _showDateFormatDialog(context, ref, dateFormat),
          ),
          _buildSettingCard(
            icon: Icons.access_time_rounded,
            title: AppLocalizations.of(context).timeFormat,
            subtitle: configs['time_format'] == 'HH:mm'
                ? AppLocalizations.of(context).numHour(24)
                : AppLocalizations.of(context).numHour(12),
            onTap: () => _showTimeFormatDialog(
              context,
              ref,
              configs['time_format'] ?? 'hh:mm a',
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocalizations.of(context).databaseReports),

          _buildSettingCard(
            icon: Icons.unarchive_rounded,
            title: AppLocalizations.of(context).backupDatabase,
            subtitle: AppLocalizations.of(context).exportAllDataToAFile,
            onTap: () => _handleExport(context),
          ),

          _buildSettingCard(
            icon: Icons.archive_rounded,
            title: AppLocalizations.of(context).restoreDatabase,
            subtitle: AppLocalizations.of(context).importNewDataFromABackupFile,
            onTap: () => _checkAuthBeforeDo(
              context,
              ref,
              () => _handleImport(context),
            ),
          ),
          _buildSettingCard(
            icon: Icons.restart_alt_rounded,
            title: AppLocalizations.of(context).resetToDefault,
            subtitle: AppLocalizations.of(
              context,
            ).restoreAllAppSettingsToFactoryDefaults,
            color: Colors.red,
            onTap: () => _checkAuthBeforeDo(
              context,
              ref,
              () => _handleResetSettings(context, ref),
            ),
          ),
          _buildSettingCard(
            icon: Icons.delete_forever_rounded,
            title: AppLocalizations.of(context).factoryReset,
            subtitle: AppLocalizations.of(context).deleteAllProductsAndHistory,
            color: Colors.red,
            onTap: () => _checkAuthBeforeDo(
              context,
              ref,
              () => _handleReset(context),
            ),
          ),

          _buildContactSection(context),

          versionAsync.when(
            data: (version) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final now = DateTime.now();

                    // 1. Logic: Reset if the gap between taps is too long (2 seconds)
                    if (_lastTapTime != null &&
                        now.difference(_lastTapTime!).inSeconds > 3) {
                      _localTapCount = 0;
                    }
                    _lastTapTime = now;

                    // 2. Increment and Update UI
                    setState(() {
                      _localTapCount++;
                    });

                    // 3. Feedback Logic
                    // if (_localTapCount > 2 && _localTapCount < 5) {
                    //   Toaster.show("Tap ${5 - _localTapCount} more times to open logs");
                    // }

                    if (_localTapCount >= 5) {
                      setState(() => _localTapCount = 0); // Reset

                      AppLogger.info(
                        "Admin accessed System Logs via 5-tap sequence.",
                      );
                      context.pushNamed(AppRoutes.logViewer.name);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context).appVersionVersion(version),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            error: (err, stack) => Center(
              child: Text(AppLocalizations.of(context).versionUnknown),
            ),
            loading: () => const Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _checkAuthBeforeDo(
    BuildContext context,
    WidgetRef ref,
    VoidCallback func,
  ) async {
    if (_isAuthenticating) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);

    // 1. Check if already verified in this session
    if (authNotifier.isSessionVerified) {
      func();
      return;
    }

    setState(() => _isAuthenticating = true);

    try {
      // 2. Otherwise, ask for Biometrics
      final success = await authNotifier.authenticateUser(context);
      if (success) {
        if (!context.mounted) return;
        func();
      }
    } finally {
      // 1.5-second cooldown to safely prevent any rapid double-triggers or OS resume events
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  void _handleResetSettings(BuildContext context, WidgetRef ref) {
    final String successMsg = AppLocalizations.of(context).settingsRestoredToDefaults;
    ConfirmDialog.show(
      context: context,
      icon: Icons.restore_rounded,
      title: AppLocalizations.of(context).resetSettings,
      message: AppLocalizations.of(
        context,
      ).thisWillRevertYourCurrencyNumbersAndAppNameTo,
      confirmLabel: AppLocalizations.of(context).resetNow,
      onConfirm: () {
        AppLogger.warning(
          "Settings: User reset all app configurations to defaults.",
        );
        // 1. Close the dialog first using the root navigator to prevent context/route invalidation
        Navigator.of(context, rootNavigator: true).pop();

        // 2. Reset configurations which triggers theme/locale rebuilds
        ref.read(configProvider.notifier).resetConfigs();

        // 3. Show success toast with pre-fetched message
        Toaster.show(successMsg);
      },
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    // 1. Check/Request permission using your helper
    bool isGranted = await PermissionHelper.requestStoragePermission();

    if (isGranted) {
      // 2. Permission is good, show the export options
      if (context.mounted) {
        _showExportBottomSheet(context);
      }
    } else {
      // 3. Permission denied, show the re-request dialog
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        ConfirmDialog.show(
          context: context,
          title: l10n.permissionRequired,
          message: l10n.storagePermissionMessage,
          confirmLabel: l10n.grant,
          icon: Icons.storage_rounded,
          onConfirm: () async {
            Navigator.of(context, rootNavigator: true).pop();

            // 2. Wait a tiny bit for the dialog transition to finish
            // to avoid the "!_debugLocked" framework error
            await Future.delayed(const Duration(milliseconds: 200));

            // 3. Re-run the check
            if (context.mounted) {
              _handleExport(context);
            }
          },
        );
      }
    }
  }

  void _showExportBottomSheet(BuildContext context) {
    int? selectedMode; // 0: Default, 1: Select, 2: Share
    bool isExporting = false;
    bool isDone = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'ExportBottomSheet'),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // Icon & Title logic based on state
              Icon(
                isDone ? Icons.check_circle_rounded : Icons.unarchive_rounded,
                size: 48,
                color: isDone ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).backupDatabase,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isDone
                    ? AppLocalizations.of(context).savedToBackups(
                        Platform.isAndroid
                            ? "Android/data/.../files/backups/"
                            : "Documents/${AppStrings.appFolder}/backups/",
                      )
                    : AppLocalizations.of(context).exportAllDataToAFile,
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // --- SELECTION LIST (Only shows if not done/exporting) ---
              if (!isExporting && !isDone) ...[
                _buildExportOption(
                  context: context,
                  index: 0,
                  icon: Icons.folder_special_rounded,
                  title: AppLocalizations.of(context).saveToDefaultBackups,
                  isSelected: selectedMode == 0,
                  onTap: () => setSheetState(() => selectedMode = 0),
                ),
                _buildExportOption(
                  context: context,
                  index: 1,
                  icon: Icons.create_new_folder_rounded,
                  title: AppLocalizations.of(context).selectFolder,
                  isSelected: selectedMode == 1,
                  onTap: () => setSheetState(() => selectedMode = 1),
                ),
                _buildExportOption(
                  context: context,
                  index: 2,
                  icon: Icons.share_rounded,
                  title: AppLocalizations.of(context).shareFile,
                  isSelected: selectedMode == 2,
                  onTap: () => setSheetState(() => selectedMode = 2),
                ),
              ],

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isExporting
                          ? null
                          : () => Navigator.pop(context),
                      child: Text(
                        isDone
                            ? AppLocalizations.of(context).close
                            : AppLocalizations.of(context).cancel,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            (isExporting || isDone || selectedMode == null)
                            ? null
                            : () async {
                                if (isExporting) return;
                                setSheetState(() => isExporting = true);

                                // 1. Request Permission
                                // 1. Request Permission
                                final hasPermission =
                                    await PermissionHelper.requestStoragePermission();

                                if (!context.mounted) return;
                                if (hasPermission) {
                                  String? result;
                                  // 2. Run Logic based on selection
                                  if (selectedMode == 0) {
                                    result =
                                        await DatabaseIOHelper.exportDatabase(
                                          context,
                                        ); // To backups/
                                  } else if (selectedMode == 1) {
                                    result =
                                        await DatabaseIOHelper.exportToSelectedFolder(
                                          context,
                                        );
                                  } else {
                                    result =
                                        await DatabaseIOHelper.shareDatabase(
                                          context,
                                        );
                                  }

                                  if (result != null &&
                                      !result.startsWith("Error")) {
                                    setSheetState(() {
                                      isExporting = false;
                                      isDone = true;
                                    });
                                    if (selectedMode == 0) {
                                      Toaster.show(
                                        AppLocalizations.of(
                                          context,
                                        ).savedToBackups(
                                          Platform.isAndroid
                                              ? "Android/data/.../files/backups"
                                              : "Documents/${AppStrings.appFolder}/backups",
                                        ),
                                      );
                                    }

                                    await Future.delayed(
                                      const Duration(milliseconds: 1500),
                                    );
                                    if (context.mounted &&
                                        GoRouter.of(context).canPop()) {
                                      context.pop();
                                    }
                                  } else {
                                    setSheetState(() => isExporting = false);
                                    Toaster.show(
                                      result ??
                                          AppLocalizations.of(
                                            context,
                                          ).exportFailed,
                                      isError: true,
                                    );
                                  }
                                } else {
                                  setSheetState(() => isExporting = false);
                                  Toaster.show(
                                    AppLocalizations.of(
                                      context,
                                    ).permissionDenied,
                                    isError: true,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDone
                              ? Colors.green
                              : Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isExporting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isDone
                                    ? AppLocalizations.of(context).success
                                    : AppLocalizations.of(context).exportNow,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for the list items
  Widget _buildExportOption({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.orange.withAlpha(isDark ? 50 : 25)
                : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.orange : (isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? Colors.orange.shade300 : Colors.orange.shade900)
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.orange, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleImport(BuildContext context) {
    ConfirmDialog.show(
      icon: Icons.archive_rounded,
      context: context,
      title: AppLocalizations.of(context).importDatabase,
      message: AppLocalizations.of(
        context,
      ).thisWillOverwriteAllCurrentBuffetDataTheAppWill,
      confirmLabel: AppLocalizations.of(context).importRestart,
      onConfirm: () async {
        AppLogger.warning(
          "Settings: User confirmed Database IMPORT. Existing data will be overwritten.",
        );
        // 1. Close the dialog and WAIT for the animation to finish
        // Using .then() ensures the next line only runs after the pop is complete
        if (mounted) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pop(); // Specifically pop the dialog/sheet
        }

        // 2. Perform the import
        final success = await DatabaseIOHelper.importDatabase(context);

        if (success) {
          if (!context.mounted) return;
          Toaster.show(AppLocalizations.of(context).importSuccessfulRestarting);

          // 3. Give the system a breath to show the toast and clear the stack
          await Future.delayed(const Duration(milliseconds: 1000));

          // 4. Force the restart
          // If this still fails, try: Restart.restartApp(notificationTitle: 'Restarting');
          AppLogger.info(
            "Settings: Import successful. Triggering App Restart.",
          );
          Restart.restartApp();
        } else {
          if (!context.mounted) return;
          Toaster.show(
            AppLocalizations.of(context).importFailed,
            isError: true,
          );
        }
      },
    );
    // REMOVED: The duplicate call that was here previously
  }

  void _showPickerBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String configKey,
    required String currentVal,
    required Map<String, String> options,
  }) {
    String tempValue = currentVal;
    bool isSaved = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'PickerBottomSheet'),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // PREVIEW CARD (Back to Orange)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSaved
                      ? Colors.green.withAlpha(15)
                      : Colors.orange.withAlpha(8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSaved ? Colors.green : Colors.orange.withAlpha(30),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  // Inside _showPickerBottomSheet -> AnimatedContainer -> Column
                  children: [
                    Text(
                      isSaved
                          ? AppLocalizations.of(context).saved
                          : AppLocalizations.of(context).livePreview,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSaved ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCurrencyPreview(
                              tempValue,
                              isSaved ? Colors.green : Colors.orange,
                            ) ??
                            SizedBox(height: 0, width: 0),
                        SizedBox(
                          width: (tempValue.contains('sar.svg') ? 8 : 0),
                        ),
                        Flexible(
                          child: Text(
                            _getPreviewText(ref, configKey, tempValue),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSaved ? Colors.green : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),

                        // THIS handles the SVG or Text LIVE as you click
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // OPTIONS LIST
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...options.entries.map(
                      (e) => _buildSelectionTile(
                        value: e
                            .key, // The path or sign (e.g. 'assets/icons/sar.svg')
                        label:
                            e.value, // The readable name (e.g. 'Saudi Riyal')
                        isSelected: e.key == tempValue,
                        onTap: isSaved
                            ? () {}
                            : () => setSheetState(() => tempValue = e.key),
                      ),
                    ),
                    const Divider(height: 24),
                    // CUSTOM FORMAT OPTION
                    _buildCustomActionTile(
                      context: context,
                      title: AppLocalizations.of(context).customT(title),
                      onTap: () {
                        Navigator.pop(context);
                        _showCustomBottomSheet(
                          context,
                          ref,
                          title,
                          configKey,
                          tempValue,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // DUAL BUTTONS: Cancel & Apply
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isSaved
                            ? null
                            : () async {
                                ref
                                    .read(configProvider.notifier)
                                    .setConfig(configKey, tempValue);
                                setSheetState(() => isSaved = true);
                                // Give the user a moment to see the "Saved" state
                                await Future.delayed(
                                  const Duration(milliseconds: 800),
                                );
                                if (context.mounted) Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          // Keep it green when saved, orange when active
                          disabledBackgroundColor: isSaved
                              ? Colors.green
                              : Colors.grey.shade300,
                          disabledForegroundColor: isSaved
                              ? Colors.white
                              : Colors.grey.shade500,
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSaved
                              ? Row(
                                  key: ValueKey('saved'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).saved,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                )
                              : Text(
                                  AppLocalizations.of(context).applyChanges,
                                  key: ValueKey('apply'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildCurrencyPreview(String value, Color color) {
    if (value.contains('.svg')) {
      return SvgPicture.asset(
        value,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else if (value.contains("\$")) {
      return Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return null;
  }

  Widget _buildSelectionTile({
    required String label,
    required String value, // Add the raw value (the key) here
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white.withOpacity(0.87) : Colors.black87;
    final selectTextColor = isSelected
        ? (isDark ? Colors.orange.shade300 : Colors.orange.shade900)
        : defaultColor;
    final selectIconColor = isSelected ? Colors.orange : defaultColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? Colors.orange.withAlpha(isDark ? 24 : 12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange
                    : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // --- NEW: SHOW ICON IN LIST ---
                if (value.contains('.svg'))
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(
                      value,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        selectIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selectTextColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.orange,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomActionTile({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Colors.orange),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNumberFormatDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    _showPickerBottomSheet(
      context: context,
      ref: ref,
      title: AppLocalizations.of(context).numbersFormat,
      configKey: 'number_format',
      currentVal: current,
      options: {'en': "123", 'ar': "١٢٣"},
    );
  }

  void _showCurrencySignDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<Map<String, String>> loadCurrencies() {
      final configs = ref.read(configProvider);
      final jsonStr = configs['custom_currencies_json'];
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final List<dynamic> parsed = json.decode(jsonStr);
          return parsed.map((e) => Map<String, String>.from(e as Map)).toList();
        } catch (_) {}
      }
      return [
        {
          'id': 'sar',
          'name': isArabic ? 'ريال سعودي' : 'Saudi Riyal',
          'symbol_ar': 'assets/icons/sar.svg',
          'symbol_en': 'SAR',
          'key': 'sar'
        },
        {
          'id': 'yer',
          'name': isArabic ? 'ريال يمني' : 'Yemeni Rial',
          'symbol_ar': 'assets/icons/sar.svg',
          'symbol_en': 'YR',
          'key': 'yer'
        },
        {
          'id': 'usd',
          'name': isArabic ? 'دولار أمريكي' : 'US Dollar',
          'symbol_ar': '\$',
          'symbol_en': '\$',
          'key': 'usd'
        },
        {
          'id': 'egp',
          'name': isArabic ? 'جنيه مصري' : 'Egyptian Pound',
          'symbol_ar': 'ج.م',
          'symbol_en': 'EGP',
          'key': 'egp'
        },
        {
          'id': 'aed',
          'name': isArabic ? 'درهم إماراتي' : 'UAE Dirham',
          'symbol_ar': 'د.إ',
          'symbol_en': 'AED',
          'key': 'aed'
        },
      ];
    }

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'CurrencyManagementSheet'),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currenciesList = loadCurrencies();
            final configs = ref.watch(configProvider);
            final activeId = configs['currency_id'] ??
                (configs['currency_sign_en'] == 'YR'
                    ? 'yer'
                    : (configs['currency_sign_en'] == 'SAR' ? 'sar' : ''));

            void saveCurrenciesList(List<Map<String, String>> updatedList) {
              final jsonStr = json.encode(updatedList);
              ref.read(configProvider.notifier).setConfig('custom_currencies_json', jsonStr);
            }

            void showAddOrEditCurrencyDialog([Map<String, String>? existingItem, int? editIndex]) {
              final nameCtrl = TextEditingController(text: existingItem?['name'] ?? '');
              final arSymbolCtrl = TextEditingController(text: existingItem?['symbol_ar'] ?? '');
              final enSymbolCtrl = TextEditingController(text: existingItem?['symbol_en'] ?? '');

              showDialog(
                context: context,
                builder: (ctx) {
                  final dialogDark = Theme.of(ctx).brightness == Brightness.dark;
                  return AlertDialog(
                    backgroundColor: dialogDark ? const Color(0xFF2C2C2C) : Colors.white,
                    title: Text(
                      existingItem != null
                          ? (isArabic ? 'تعديل عملة' : 'Edit Currency')
                          : (isArabic ? 'إضافة عملة جديدة' : 'Add New Currency'),
                      style: TextStyle(color: dialogDark ? Colors.white : Colors.black87),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameCtrl,
                            style: TextStyle(color: dialogDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              labelText: isArabic ? 'اسم العملة' : 'Currency Name',
                              hintText: isArabic ? 'مثال: دينار كويتي' : 'e.g. Kuwaiti Dinar',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: arSymbolCtrl,
                            style: TextStyle(color: dialogDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              labelText: isArabic ? 'الرمز بالعربية' : 'Arabic Symbol',
                              hintText: isArabic ? 'مثال: د.ك (أو assets/icons/sar.svg)' : 'e.g. د.ك',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: enSymbolCtrl,
                            style: TextStyle(color: dialogDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              labelText: isArabic ? 'الرمز بالإنجليزية' : 'English Symbol',
                              hintText: isArabic ? 'مثال: KWD' : 'e.g. KWD',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: context.primaryColor),
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final arSym = arSymbolCtrl.text.trim();
                          final enSym = enSymbolCtrl.text.trim();

                          if (name.isNotEmpty && arSym.isNotEmpty && enSym.isNotEmpty) {
                            final newItemId = existingItem?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
                            final newItem = {
                              'id': newItemId,
                              'name': name,
                              'symbol_ar': arSym,
                              'symbol_en': enSym,
                              'key': newItemId,
                            };

                            final list = List<Map<String, String>>.from(currenciesList);
                            if (editIndex != null && editIndex >= 0 && editIndex < list.length) {
                              list[editIndex] = newItem;
                            } else {
                              list.add(newItem);
                            }

                            saveCurrenciesList(list);

                            ref.read(configProvider.notifier).setConfig('currency_id', newItemId);
                            ref.read(configProvider.notifier).setConfig('currency_sign', arSym);
                            ref.read(configProvider.notifier).setConfig('currency_sign_ar', arSym);
                            ref.read(configProvider.notifier).setConfig('currency_sign_en', enSym);

                            Navigator.pop(ctx);
                            setSheetState(() {});
                          }
                        },
                        child: Text(isArabic ? 'حفظ' : 'Save', style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? 'إدارة العملات' : 'Currency Management',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                        tooltip: isArabic ? 'إضافة عملة' : 'Add Currency',
                        onPressed: () => showAddOrEditCurrencyDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: currenciesList.length,
                      itemBuilder: (context, index) {
                        final item = currenciesList[index];
                        final itemId = item['id'] ?? item['key'] ?? '';
                        final arSym = item['symbol_ar'] ?? '';
                        final enSym = item['symbol_en'] ?? '';
                        final isSelected = (activeId.isNotEmpty && itemId == activeId) ||
                            (activeId.isEmpty && (arSym == configs['currency_sign'] && enSym == configs['currency_sign_en']));

                        final arDisplay = arSym.contains('.svg')
                            ? (isArabic ? 'أيقونة الريال (SVG)' : 'Rial SVG')
                            : arSym;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: isSelected ? Colors.orange.withAlpha(isDark ? 24 : 12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected ? Colors.orange : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              leading: arSym.contains('.svg')
                                  ? SvgPicture.asset(arSym, width: 24, height: 24)
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withAlpha(20),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        arSym,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                                      ),
                                    ),
                              title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${isArabic ? "الرمز بالعربية:" : "Ar:"} $arDisplay  |  ${isArabic ? "بالإنجليزية:" : "En:"} $enSym',
                                style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
                                    onPressed: () => showAddOrEditCurrencyDialog(item, index),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle_rounded, color: Colors.orange, size: 22),
                                ],
                              ),
                              onTap: () {
                                ref.read(configProvider.notifier).setConfig('currency_id', itemId);
                                ref.read(configProvider.notifier).setConfig('currency_sign', arSym);
                                ref.read(configProvider.notifier).setConfig('currency_sign_ar', arSym);
                                ref.read(configProvider.notifier).setConfig('currency_sign_en', enSym);
                                setSheetState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      isArabic ? 'إضافة عملة جديدة' : 'Add New Currency',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => showAddOrEditCurrencyDialog(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDateFormatDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    _showPickerBottomSheet(
      context: context,
      ref: ref,
      title: AppLocalizations.of(context).dateFormat,
      configKey: 'date_format',
      currentVal: current,
      options: {
        'dd/MM/yyyy': 'DD/MM/YYYY',
        'MM/dd/yyyy': 'MM/DD/YYYY',
        'yyyy-MM-dd': 'YYYY-MM-DD',
      },
    );
  }

  void _showTimeFormatDialog(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    _showPickerBottomSheet(
      context: context,
      ref: ref,
      title: AppLocalizations.of(context).timeFormat,
      configKey: 'time_format',
      currentVal: current,
      options: {
        'hh:mm a': AppLocalizations.of(context).numHour(12),
        'HH:mm': AppLocalizations.of(context).numHour(24),
      },
    );
  }

  // --- UNIFIED BOTTOM SHEET HELPER ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: context.primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    IconData? trailingIcon,
    required String title,
    required dynamic subtitle, // Changed to dynamic to accept String or Widget
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardTheme = Theme.of(context).cardTheme;
    final cardColor = cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50);
    final borderColor = cardTheme.shape is RoundedRectangleBorder
        ? (cardTheme.shape as RoundedRectangleBorder).side.color
        : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor:
              color?.withAlpha(20) ?? context.primaryColor.withAlpha(20),
          highlightColor:
              color?.withAlpha(10) ?? context.primaryColor.withAlpha(10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor:
                  color?.withAlpha(20) ?? context.primaryColor.withAlpha(20),
              child: Icon(icon, color: color ?? context.primaryColor, size: 22),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // --- Logic to handle String or Widget ---
            subtitle: subtitle is Widget
                ? subtitle
                : Text(
                    subtitle.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
            trailing: Icon(
              trailingIcon ?? Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  String _getPreviewText(WidgetRef ref, String key, String value) {
    final now = DateTime.now();
    final configs = ref.read(configProvider);

    // We get the "other" settings to make the preview feel real
    // e.g., if changing date format, we still use the current number format
    final numLoc = configs['number_format'] ?? 'en';

    switch (key) {
      case 'number_format':
        // Sample: 1250.5
        return value == 'ar' ? "١,٢٥٠.٥٠" : "1,250.50";

      case 'currency_sign':
        // Sample: shows how the currency looks with localized digits
        String price = numLoc == 'ar' ? "١,٢٥٠.٥٠" : "1,250.50";
        return price;

      case 'date_format':
        try {
          // Patterns like dd/MM/yyyy
          return DateFormat(value, numLoc == 'ar' ? 'ar_SA' : 'en').format(now);
        } catch (_) {
          return AppLocalizations.of(context).invalidPattern;
        }

      case 'time_format':
        try {
          // Patterns like hh:mm a
          String formatted = DateFormat(value, numLoc == 'ar' ? 'ar_SA' : 'en').format(now);
          final appLang = configs['language'] ?? 'system';
          final isArabic = appLang == 'ar' ||
              (appLang == 'system' && Intl.systemLocale.startsWith('ar'));
          if (isArabic) {
            formatted = formatted
                .replaceAll('AM', 'ص')
                .replaceAll('PM', 'م')
                .replaceAll('am', 'ص')
                .replaceAll('pm', 'م')
                .replaceAll('a.m.', 'ص')
                .replaceAll('p.m.', 'م');
          }
          return formatted;
        } catch (_) {
          return AppLocalizations.of(context).invalidPattern;
        }

      default:
        return value;
    }
  }

  void _handleReset(BuildContext context) {
    ConfirmDialog.show(
      context: context,
      title: AppLocalizations.of(context).dangerousAction,
      message: AppLocalizations.of(
        context,
      ).thisWillWipeYourEntireDatabaseAreYouAbsolutelySure,
      confirmLabel: AppLocalizations.of(context).resetAll,
      onConfirm: () async {
        // 1. Close dialog using the root navigator to prevent context/route invalidation
        Navigator.of(context, rootNavigator: true).pop();

        // 2. Perform the wipe
        final success = await DatabaseIOHelper.resetDatabase(context);

        if (success) {
          if (!context.mounted) return;
          Toaster.show(
            AppLocalizations.of(context).systemResetSuccessfulRestarting,
          );

          // 3. Wait for Toast
          await Future.delayed(const Duration(milliseconds: 1000));

          // 4. Restart to re-initialize fresh DB
          Restart.restartApp();
        } else {
          if (!context.mounted) return;
          Toaster.show(AppLocalizations.of(context).resetFailed, isError: true);
        }
      },
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'EditNameDialog'),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            AppLocalizations.of(context).editBuffetName,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).enterBuffetName,
              hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.primaryColor),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
              ),
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  // SAVE TO DATABASE via your Provider
                  ref
                      .read(configProvider.notifier)
                      .setConfig('business_name', newName);
                  Navigator.pop(context);
                }
              },
              child: Text(
                AppLocalizations.of(context).save,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    String currentLang,
  ) {
    String tempValue = currentLang;
    bool isSaved = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'LanguageDialogSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppLocalizations.of(context).appLanguage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // PREVIEW CARD
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSaved
                      ? Colors.green.withAlpha(15)
                      : context.primaryColor.withAlpha(8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSaved
                        ? Colors.green
                        : context.primaryColor.withAlpha(30),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      isSaved
                          ? AppLocalizations.of(context).saved
                          : AppLocalizations.of(context).livePreview,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isSaved ? Colors.green : context.primaryColor,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      () {
                        String resolveLang = tempValue;
                        if (tempValue == 'system') {
                          resolveLang =
                              PlatformDispatcher.instance.locale.languageCode;
                        }
                        return resolveLang == 'ar'
                            ? AppLocalizations.of(
                                context,
                              ).welcomeToBuffetPreviewAr
                            : AppLocalizations.of(
                                context,
                              ).welcomeToBuffetPreviewEn;
                      }(),
                      style: TextStyle(
                        fontFamily: () {
                          String resolveLang = tempValue;
                          if (tempValue == 'system') {
                            resolveLang =
                                PlatformDispatcher.instance.locale.languageCode;
                          }
                          return resolveLang == 'ar' ? 'Tajawal' : 'Roboto';
                        }(),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSaved ? Colors.green : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // LANGUAGE OPTIONS
              _buildSelectionTile(
                value: 'system',
                label:
                    "${AppLocalizations.of(context).systemDefault} (${PlatformDispatcher.instance.locale.languageCode == 'ar' ? 'العربية' : 'English'})",
                isSelected: tempValue == 'system',
                onTap: isSaved
                    ? () {}
                    : () => setSheetState(() => tempValue = 'system'),
              ),
              _buildSelectionTile(
                value: 'en',
                label: "English (US)",
                isSelected: tempValue == 'en',
                onTap: isSaved
                    ? () {}
                    : () => setSheetState(() => tempValue = 'en'),
              ),
              _buildSelectionTile(
                value: 'ar',
                label:
                    "العربية", // Keep the actual language name as a native noun
                isSelected: tempValue == 'ar',
                onTap: isSaved
                    ? () {}
                    : () => setSheetState(() => tempValue = 'ar'),
              ),

              const SizedBox(height: 24),

              // DUAL ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved
                              ? Colors.green
                              : context.primaryColor,
                        ),
                        onPressed: isSaved
                            ? null
                            : () async {
                                // 1. Save language
                                await ref
                                    .read(configProvider.notifier)
                                    .setConfig('language', tempValue);

                                // 2. Visual Feedback
                                setSheetState(() => isSaved = true);

                                // 3. Short delay to let user see "Saved" before sheet closes
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                        child: isSaved
                            ? const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              )
                            : Text(
                                AppLocalizations.of(context).applyLanguage,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    String currentTheme,
  ) {
    String tempValue = currentTheme;
    bool isSaved = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'ThemeDialogSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppLocalizations.of(context).themeMode,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // THEME OPTIONS
              _buildSelectionTile(
                value: 'light',
                label: AppLocalizations.of(context).lightMode,
                isSelected: tempValue == 'light',
                onTap: isSaved
                    ? () {}
                    : () => setSheetState(() => tempValue = 'light'),
              ),
              _buildSelectionTile(
                value: 'dark',
                label: AppLocalizations.of(context).darkMode,
                isSelected: tempValue == 'dark',
                onTap: isSaved
                    ? () {}
                    : () => setSheetState(() => tempValue = 'dark'),
              ),

              const SizedBox(height: 24),

              // DUAL ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved
                              ? Colors.green
                              : context.primaryColor,
                        ),
                        onPressed: isSaved
                            ? null
                            : () async {
                                // 1. Save theme
                                await ref
                                    .read(configProvider.notifier)
                                    .setConfig('theme_mode', tempValue);

                                // 2. Visual Feedback
                                setSheetState(() => isSaved = true);

                                // 3. Short delay to let user see "Saved" before sheet closes
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                        child: isSaved
                            ? const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              )
                            : Text(
                                AppLocalizations.of(context).applyChanges,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String title,
    String key,
    String current,
  ) {
    final controller = TextEditingController(
      text: current.contains('.svg') ? "" : current,
    );
    bool isSaved = false; // Local state for the success animation
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: 'CustomFormatSheet'),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppLocalizations.of(context).customT(title),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // LIVE PREVIEW BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSaved
                      ? Colors.green.withAlpha(10)
                      : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSaved
                        ? Colors.green.withAlpha(50)
                        : (isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).livePreview,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPreviewText(ref, key, controller.text),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSaved ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                autofocus: true,
                enabled: !isSaved, // Disable input while "Saving"
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onChanged: (_) => setSheetState(() {}),
                decoration: InputDecoration(
                  hintText: "e.g. yyyy-MM-dd",
                  hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: context.primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ANIMATED SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSaved ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isSaved
                        ? null
                        : () async {
                            final val = controller.text.trim();
                            if (val.isNotEmpty) {
                              // 1. Perform the Save
                              ref
                                  .read(configProvider.notifier)
                                  .setConfig(key, val);

                              // 2. Show Success State
                              setSheetState(() => isSaved = true);

                              // 3. Wait 800ms so the user can see the success
                              await Future.delayed(
                                const Duration(milliseconds: 800),
                              );

                              // 4. Finally close
                              // if (context.mounted) Navigator.pop(context);
                            }
                          },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isSaved
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).savedSuccessfully,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Text(
                              AppLocalizations.of(context).applyChanges,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACCOUNT INFORMATION SECTION
  // ─────────────────────────────────────────────

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountAsync = ref.watch(accountInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(isAr ? 'معلومات الحساب' : 'Account Information'),
        accountAsync.when(
          data: (account) {
            if (account == null) {
              // ── No account yet ──
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: context.primaryColor.withAlpha(20),
                    child: Icon(Icons.person_add_rounded, color: context.primaryColor),
                  ),
                  title: Text(
                    isAr ? 'لا يوجد حساب مُنشأ' : 'No account created',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    isAr ? 'اضغط لإنشاء حساب جديد' : 'Tap to create a new account',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAr ? 'إنشاء' : 'Create',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  onTap: () => _showCreateAccountSheet(context, ref),
                ),
              );
            }

            // ── Account exists ──
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  // Header with avatar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: context.primaryColor.withAlpha(20),
                          child: Text(
                            (account['full_name'] as String? ?? 'U')
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['full_name'] as String? ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                account['email'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Info rows
                  _buildAccountInfoRow(
                    icon: Icons.phone_rounded,
                    label: isAr ? 'رقم الهاتف' : 'Phone',
                    value: '${account['country_code'] ?? ''} ${account['phone_number'] ?? ''}',
                    isDark: isDark,
                  ),
                  _buildAccountInfoRow(
                    icon: Icons.email_rounded,
                    label: isAr ? 'البريد الإلكتروني' : 'Email',
                    value: account['email'] as String? ?? '',
                    isDark: isDark,
                  ),
                  _buildAccountInfoRow(
                    icon: Icons.lock_rounded,
                    label: isAr ? 'كلمة المرور' : 'Password',
                    value: '••••••••',
                    isDark: isDark,
                  ),
                  const Divider(height: 1),
                  // Edit button
                  ListTile(
                    onTap: () => _showEditAccountSheet(context, ref, account),
                    leading: CircleAvatar(
                      backgroundColor: context.primaryColor.withAlpha(20),
                      child: Icon(Icons.edit_rounded, color: context.primaryColor, size: 20),
                    ),
                    title: Text(
                      isAr ? 'تعديل بيانات الحساب' : 'Edit Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.primaryColor,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text(e.toString()),
        ),
      ],
    );
  }

  Widget _buildAccountInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade300),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ── Country Code Picker Sheet ──
  void _showCountryPickerSheet(
    BuildContext context,
    Country selectedCountry,
    Function(Country) onCountrySelected,
  ) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filteredCountries = countriesList.where((country) {
              final name = isArabic ? country.nameAr : country.nameEn;
              final matchesName = name.toLowerCase().contains(searchQuery.toLowerCase());
              final matchesDialCode = country.dialCode.contains(searchQuery);
              return matchesName || matchesDialCode;
            }).toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.8,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Top Drag handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        hintText: l10n.searchCountry,
                        hintStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search_rounded, color: context.primaryColor),
                        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Country List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (ctx, index) {
                        final country = filteredCountries[index];
                        final isSelected = country.code == selectedCountry.code ||
                            country.dialCode == selectedCountry.dialCode;

                        return ListTile(
                          onTap: () {
                            onCountrySelected(country);
                            Navigator.pop(ctx);
                          },
                          leading: Text(
                            country.flag,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            country.getName(isArabic ? 'ar' : 'en'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? context.primaryColor
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                country.dialCode,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_rounded, color: context.primaryColor),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Create Account Sheet ──
  void _showCreateAccountSheet(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final codeCtrl = TextEditingController(text: '+967');
    Country selectedCountry = countriesList.firstWhere(
      (c) => c.dialCode == codeCtrl.text || c.code == 'YE',
      orElse: () => countriesList.first,
    );
    final passCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscurePass = true;
    bool obscureConfirm = true;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CreateAccountSheet'),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          height: MediaQuery.of(ctx).size.height,
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(ctx).padding.top + 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        isAr ? 'إلغاء' : 'Cancel',
                        style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isAr ? 'إنشاء حساب' : 'Create Account',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24, right: 24, top: 28,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 40,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountField(label: isAr ? 'الاسم الكامل' : 'Full Name', ctrl: nameCtrl, icon: Icons.person_rounded, isAr: isAr, validator: (v) => (v == null || v.trim().isEmpty) ? (isAr ? 'مطلوب' : 'Required') : null),
                        const SizedBox(height: 20),
                        _buildAccountField(label: isAr ? 'البريد الإلكتروني' : 'Email', ctrl: emailCtrl, icon: Icons.email_rounded, isAr: isAr, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? (isAr ? 'بريد غير صالح' : 'Invalid email') : null),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'رقم الهاتف' : 'Phone Number',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showCountryPickerSheet(
                                      ctx,
                                      selectedCountry,
                                      (country) {
                                        setS(() {
                                          selectedCountry = country;
                                          codeCtrl.text = country.dialCode;
                                        });
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(ctx).brightness == Brightness.dark
                                          ? const Color(0xFF2C2C2C)
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Theme.of(ctx).brightness == Brightness.dark
                                            ? const Color(0xFF3C3C3C)
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          selectedCountry.flag,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          selectedCountry.dialCode,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(ctx).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Theme.of(ctx).brightness == Brightness.dark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: Theme.of(ctx).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "123456789",
                                      prefixIcon: Icon(Icons.phone_rounded, color: context.primaryColor, size: 20),
                                      filled: true,
                                      fillColor: Theme.of(ctx).brightness == Brightness.dark
                                          ? const Color(0xFF2C2C2C)
                                          : Colors.grey.shade50,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: Theme.of(ctx).brightness == Brightness.dark
                                            ? const BorderSide(color: Color(0xFF3C3C3C))
                                            : BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(color: context.primaryColor, width: 1.5),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 1.5),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return isAr ? 'رقم الهاتف مطلوب' : 'Phone number is required';
                                      }
                                      final phoneDigitsOnly = v.replaceAll(RegExp(r'\D'), '');
                                      if (phoneDigitsOnly.length < 7) {
                                        return isAr ? 'رقم الهاتف غير صالح' : 'Invalid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildAccountField(
                          label: isAr ? 'كلمة المرور' : 'Password',
                          ctrl: passCtrl,
                          icon: Icons.lock_rounded,
                          isAr: isAr,
                          obscure: obscurePass,
                          onToggleObscure: () => setS(() => obscurePass = !obscurePass),
                          validator: (v) => (v == null || v.length < 4) ? (isAr ? 'على الأقل 4 أحرف' : 'Min 4 chars') : null,
                        ),
                        const SizedBox(height: 20),
                        _buildAccountField(
                          label: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
                          ctrl: confirmPassCtrl,
                          icon: Icons.lock_outline_rounded,
                          isAr: isAr,
                          obscure: obscureConfirm,
                          onToggleObscure: () => setS(() => obscureConfirm = !obscureConfirm),
                          validator: (v) => v != passCtrl.text ? (isAr ? 'كلمات المرور غير متطابقة' : 'Passwords do not match') : null,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await ref.read(authDatabaseServiceProvider).registerUser(
                                  fullName: nameCtrl.text,
                                  phoneNumber: phoneCtrl.text,
                                  countryCode: codeCtrl.text,
                                  email: emailCtrl.text,
                                  password: passCtrl.text,
                                );
                                ref.invalidate(accountInfoProvider);
                                if (ctx.mounted) Navigator.pop(ctx);
                                Toaster.show(isAr ? 'تم إنشاء الحساب بنجاح ✓' : 'Account created successfully ✓');
                              }
                            },
                            child: Text(
                              isAr ? 'إنشاء الحساب' : 'Create Account',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit Account Sheet ──
  void _showEditAccountSheet(BuildContext context, WidgetRef ref, Map<String, dynamic> account) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: account['full_name'] as String? ?? '');
    final emailCtrl = TextEditingController(text: account['email'] as String? ?? '');
    final phoneCtrl = TextEditingController(text: account['phone_number'] as String? ?? '');
    final codeCtrl = TextEditingController(text: account['country_code'] as String? ?? '+967');
    final initialCode = account['country_code'] as String? ?? '+967';
    Country selectedCountry = countriesList.firstWhere(
      (c) => c.dialCode.trim() == initialCode.trim(),
      orElse: () => countriesList.firstWhere(
        (c) => c.code == 'YE',
        orElse: () => countriesList.first,
      ),
    );
    // Password change fields
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool changePassword = false;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final userId = account['id'] as int;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'EditAccountSheet'),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          height: MediaQuery.of(ctx).size.height,
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(ctx).padding.top + 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        isAr ? 'إلغاء' : 'Cancel',
                        style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isAr ? 'تعديل الحساب' : 'Edit Account',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24, right: 24, top: 28,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 40,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountField(label: isAr ? 'الاسم الكامل' : 'Full Name', ctrl: nameCtrl, icon: Icons.person_rounded, isAr: isAr, validator: (v) => (v == null || v.trim().isEmpty) ? (isAr ? 'مطلوب' : 'Required') : null),
                        const SizedBox(height: 20),
                        _buildAccountField(label: isAr ? 'البريد الإلكتروني' : 'Email', ctrl: emailCtrl, icon: Icons.email_rounded, isAr: isAr, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? (isAr ? 'بريد غير صالح' : 'Invalid email') : null),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'رقم الهاتف' : 'Phone Number',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showCountryPickerSheet(
                                      ctx,
                                      selectedCountry,
                                      (country) {
                                        setS(() {
                                          selectedCountry = country;
                                          codeCtrl.text = country.dialCode;
                                        });
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(ctx).brightness == Brightness.dark
                                          ? const Color(0xFF2C2C2C)
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Theme.of(ctx).brightness == Brightness.dark
                                            ? const Color(0xFF3C3C3C)
                                            : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          selectedCountry.flag,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          selectedCountry.dialCode,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(ctx).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Theme.of(ctx).brightness == Brightness.dark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: Theme.of(ctx).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "123456789",
                                      prefixIcon: Icon(Icons.phone_rounded, color: context.primaryColor, size: 20),
                                      filled: true,
                                      fillColor: Theme.of(ctx).brightness == Brightness.dark
                                          ? const Color(0xFF2C2C2C)
                                          : Colors.grey.shade50,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: Theme.of(ctx).brightness == Brightness.dark
                                            ? const BorderSide(color: Color(0xFF3C3C3C))
                                            : BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(color: context.primaryColor, width: 1.5),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: Colors.red, width: 1.5),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return isAr ? 'رقم الهاتف مطلوب' : 'Phone number is required';
                                      }
                                      final phoneDigitsOnly = v.replaceAll(RegExp(r'\D'), '');
                                      if (phoneDigitsOnly.length < 7) {
                                        return isAr ? 'رقم الهاتف غير صالح' : 'Invalid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Password change toggle
                        Container(
                          decoration: BoxDecoration(
                            color: changePassword
                                ? context.primaryColor.withAlpha(10)
                                : (Theme.of(ctx).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: changePassword ? context.primaryColor.withAlpha(80) : Colors.transparent,
                            ),
                          ),
                          child: SwitchListTile(
                            value: changePassword,
                            onChanged: (val) => setS(() => changePassword = val),
                            activeColor: context.primaryColor,
                            title: Text(
                              isAr ? 'تغيير كلمة المرور' : 'Change Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: changePassword ? context.primaryColor : null,
                              ),
                            ),
                            secondary: Icon(
                              Icons.lock_rounded,
                              color: changePassword ? context.primaryColor : Colors.grey,
                            ),
                          ),
                        ),

                        if (changePassword) ...[
                          const SizedBox(height: 20),
                          _buildAccountField(
                            label: isAr ? 'كلمة المرور الحالية' : 'Current Password',
                            ctrl: currentPassCtrl,
                            icon: Icons.lock_rounded,
                            isAr: isAr,
                            obscure: obscureCurrent,
                            onToggleObscure: () => setS(() => obscureCurrent = !obscureCurrent),
                            validator: (v) => changePassword && (v == null || v.isEmpty) ? (isAr ? 'مطلوب' : 'Required') : null,
                          ),
                          const SizedBox(height: 20),
                          _buildAccountField(
                            label: isAr ? 'كلمة المرور الجديدة' : 'New Password',
                            ctrl: newPassCtrl,
                            icon: Icons.lock_open_rounded,
                            isAr: isAr,
                            obscure: obscureNew,
                            onToggleObscure: () => setS(() => obscureNew = !obscureNew),
                            validator: (v) => changePassword && (v == null || v.length < 4) ? (isAr ? 'على الأقل 4 أحرف' : 'Min 4 chars') : null,
                          ),
                          const SizedBox(height: 20),
                          _buildAccountField(
                            label: isAr ? 'تأكيد كلمة المرور الجديدة' : 'Confirm New Password',
                            ctrl: confirmPassCtrl,
                            icon: Icons.lock_outline_rounded,
                            isAr: isAr,
                            obscure: obscureConfirm,
                            onToggleObscure: () => setS(() => obscureConfirm = !obscureConfirm),
                            validator: (v) => changePassword && v != newPassCtrl.text ? (isAr ? 'كلمات المرور غير متطابقة' : 'Passwords do not match') : null,
                          ),
                        ],

                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;
                              final svc = ref.read(authDatabaseServiceProvider);

                              // 1. Update profile info
                              await svc.updateUser(
                                id: userId,
                                fullName: nameCtrl.text,
                                phoneNumber: phoneCtrl.text,
                                countryCode: codeCtrl.text,
                                email: emailCtrl.text,
                              );

                              // 2. Change password if toggled
                              if (changePassword) {
                                final success = await svc.changePassword(
                                  id: userId,
                                  currentPassword: currentPassCtrl.text,
                                  newPassword: newPassCtrl.text,
                                );
                                if (!success) {
                                  Toaster.show(
                                    isAr ? 'كلمة المرور الحالية غير صحيحة' : 'Current password is incorrect',
                                    isError: true,
                                  );
                                  return;
                                }
                              }

                              ref.invalidate(accountInfoProvider);
                              if (ctx.mounted) Navigator.pop(ctx);
                              Toaster.show(isAr ? 'تم تحديث الحساب بنجاح ✓' : 'Account updated successfully ✓');
                            },
                            child: Text(
                              isAr ? 'حفظ التغييرات' : 'Save Changes',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountField({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    required bool isAr,
    TextInputType keyboardType = TextInputType.text,
    bool? obscure,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          obscureText: obscure ?? false,
          validator: validator,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: context.primaryColor, size: 20),
            suffixIcon: obscure != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: context.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final titleText = isArabic
        ? 'للتواصل مع المسؤول لأي استفسار أو طلب نسخة سطح المكتب (البرنامج للكمبيوتر واللابتوب) اضغط على الأيقونة'
        : 'To contact the administrator for any inquiry or to request the desktop version (program for PC and laptop), click on the icon';

    // SVG icons for corporate platforms
    const String whatsappSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32"><path fill="#ffffff" d="M12.012 2c-5.506 0-9.972 4.466-9.972 9.97 0 1.76.459 3.475 1.333 4.992L2 22l5.22-.1.37-.12a9.924 9.924 0 0 0 4.422 1.05h.004c5.502 0 9.97-4.468 9.97-9.97a9.924 9.924 0 0 0-2.92-7.05A9.924 9.924 0 0 0 12.012 2zm0 1.636c4.61 0 8.334 3.725 8.334 8.334a8.3 8.3 0 0 1-2.44 5.9 8.3 8.3 0 0 1-5.894 2.434h-.002c-1.576 0-3.118-.432-4.46-1.25l-.32-.19-3.3.064.25-3.17-.208-.33a8.27 8.27 0 0 1-1.29-4.458c0-4.61 3.726-8.334 8.334-8.334zm-3.528 2.89a.833.833 0 0 0-.584.28c-.23.245-.584.6-.584 1.458s.624 1.688.71 1.808c.088.118 1.206 1.84 2.922 2.58.41.176.73.28.98.36.41.13.788.11 1.084.067.33-.048 1.018-.415 1.16-.816a.833.833 0 0 0 .1-.584c-.04-.07-.15-.11-.32-.19-.168-.08-1.018-.5-1.176-.557-.158-.056-.27-.084-.386.084-.116.168-.45.557-.55.67-.1.11-.2.13-.37.04-.17-.084-.716-.263-1.365-.843-.5-.447-.84-.997-.94-1.166-.1-.17-.01-.26.075-.345.077-.077.168-.19.25-.29.085-.098.114-.17.17-.28a.333.333 0 0 0-.016-.317c-.048-.098-.386-.93-.53-1.277-.14-.338-.282-.292-.387-.297-.1-.005-.216-.005-.333-.005z"/></svg>''';
    
    const String facebookSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32"><path fill="#ffffff" d="M22 12c0-5.52-4.48-10-10-10S2 6.48 2 12c0 4.84 3.44 8.87 8 9.8V15H8v-3h2V9.5C10 7.57 11.57 6 13.5 6H16v3h-2c-.55 0-1 .45-1 1v2h3v3h-3v6.8c4.56-.93 8-4.96 8-9.8z"/></svg>''';
    
    const String instagramSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32"><path fill="#ffffff" d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051C.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 0 0 0-12.324zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm6.406-11.845a1.44 1.44 0 1 0 0 2.881 1.44 1.44 0 0 0 0-2.881z"/></svg>''';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // WhatsApp
              _buildSocialButton(
                color: const Color(0xFF25D366),
                svgString: whatsappSvg,
                onTap: () => _launchContactUrl('https://wa.me/967775119035'), // Replace with actual WhatsApp link
              ),
              const SizedBox(width: 20),
              // Facebook
              _buildSocialButton(
                color: const Color(0xFF1877F2),
                svgString: facebookSvg,
                onTap: () => _launchContactUrl('https://www.facebook.com/share/1FkZ3JBMum/?mibextid=qi2Omg'), // Replace with actual Facebook link
              ),
              const SizedBox(width: 20),
              // Instagram
              _buildSocialButton(
                color: const Color(0xFFE1306C),
                svgString: instagramSvg,
                onTap: () => _launchContactUrl('https://www.instagram.com/a7m_z7?igsh=MW53eThoYzBxdTM1aA=='), // Replace with actual Instagram link
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required Color color,
    required String svgString,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: SvgPicture.string(
            svgString,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }

  Future<void> _launchContactUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Toaster.show(
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'تعذر فتح الرابط'
            : 'Could not open link',
        isError: true,
      );
    }
  }
}
