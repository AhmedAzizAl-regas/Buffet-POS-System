import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AppLogger {
  // Synchronously initialize a console-only logger to avoid LateInitializationError
  static Logger _logger = Logger(
    printer: BuffetLogPrinter(),
    output: ConsoleOutput(),
  );
  static late File _logFile;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/buffet_app_logs.txt');

      if (await _logFile.exists()) {
        final size = await _logFile.length();
        if (size > 5 * 1024 * 1024) {
          await clearLogs();
          debugPrint("Log file exceeded 5MB and was cleared.");
        }
      }

      // "Upgrade" the logger to include file output
      _logger = Logger(
        printer: BuffetLogPrinter(),
        output: MultiOutput([
          ConsoleOutput(),
          FileOutput(file: _logFile, overrideExisting: false),
        ]),
      );

      Logger.level = kReleaseMode ? Level.info : Level.all;
      _initialized = true;
      debugPrint("AppLogger: Background file-logging initialization complete.");
    } catch (e) {
      debugPrint("AppLogger init failed: $e");
      // Fallback is already running (console only)
    }
  }

  // --- GETTERS ---

  /// Returns the raw File object (Used by LogViewer for sharing)
  static Future<File> getLogFile() async => _logFile;

  /// Returns the cleaned string content of the log file
  static Future<String> getLogContent() async {
    if (await _logFile.exists()) {
      final rawContent = await _logFile.readAsString(encoding: utf8);
      return rawContent.replaceAll('\x00', '');
    }
    return "No logs found.";
  }

  // --- LOGGING METHODS ---

  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // --- ACTIONS ---

  static Future<void> shareLogFile() async {
    try {
      if (await _logFile.exists()) {
        final content = await getLogContent();
        await _logFile.writeAsString(content);

        await Share.shareXFiles(
          [XFile(_logFile.path)],
          subject: 'Buffet App System Logs',
          text: 'System logs for troubleshooting.',
        );
      }
    } catch (e) {
      debugPrint("Error sharing log file: $e");
    }
  }

  static Future<void> clearLogs() async {
    if (await _logFile.exists()) {
      await _logFile.writeAsString("");
    }
  }
}

class BuffetLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    // Force 'en_US' locale to keep numbers as 0-9 consistently
    final String dateStr = DateFormat(
      'yyyy-MM-dd',
      'en',
    ).format(DateTime.now());
    final String timeStr = DateFormat('HH:mm:ss', 'en').format(DateTime.now());

    String emoji = "💡";
    if (event.level == Level.error) emoji = "❌";
    if (event.level == Level.warning) emoji = "⚠️";
    if (event.level == Level.debug) emoji = "🐛";

    final cleanMessage = event.message.toString().replaceAll('\x00', '');
    String logLine = "[$dateStr | $timeStr] $emoji $cleanMessage";

    List<String> output = [logLine];

    if (event.error != null) {
      output.add("Error: ${event.error}");
    }
    if (event.stackTrace != null) {
      output.add(event.stackTrace.toString());
    }

    return output;
  }
}

class NavObserverNew extends NavigatorObserver {
  String _getRouteName(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) return name;

    // If name is null, use r)untimeType to identify if it's a Dialog, BottomSheet, etc.
    final typeName = route.runtimeType.toString();
    final args = route.settings.arguments;

    if (args != null) {
      // Don't log args content — may contain PII (customer names, notes)
      return '[$typeName] (has args)';
    }
    return '[$typeName]';
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    AppLogger.info('NAV PUSH: ${_getRouteName(route)}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppLogger.info('NAV POP: ${_getRouteName(route)}');
  }
}
