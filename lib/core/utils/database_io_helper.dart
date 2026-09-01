import 'dart:io';

import 'package:buffet_app/core/constants/app_strings.dart';
import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:buffet_app/core/utils/file_naming.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseIOHelper {
  static const String dbName = AppStrings.dbName;

  // --- 1. SAVE TO DEFAULT (Documents/POS/backups/) ---
  static Future<String?> exportDatabase(BuildContext context) async {
    try {
      AppLogger.info("DatabaseIO: Starting automated export to default storage.");
      final dbPath = await getDatabasesPath();
      final File dbFile = File(join(dbPath, dbName));

      if (!await dbFile.exists()) {
        AppLogger.error(
          "DatabaseIO: Export failed - Source DB file not found at $dbPath",
        );
        return "Error: DB not found";
      }

      Directory targetDir;
      if (Platform.isAndroid) {
        final extDir = await getExternalStorageDirectory();
        if (extDir == null) {
          return "Error: External storage not available";
        }
        targetDir = Directory(join(extDir.path, 'backups'));
      } else {
        final docs = await getApplicationDocumentsDirectory();
        targetDir = Directory(join(docs.path, AppStrings.appFolder, 'backups'));
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
        AppLogger.debug("DatabaseIO: Created backup directory at ${targetDir.path}");
      }

      final String finalPath = join(targetDir.path, FileNaming.generateBackupName());
      await dbFile.copy(finalPath);

      final size = await File(finalPath).length();
      AppLogger.info("DatabaseIO: Export SUCCESSFUL. File saved to: $finalPath (${(size / 1024).toStringAsFixed(2)} KB)");
      return finalPath;
    } catch (e, stack) {
      AppLogger.error("DatabaseIO: Default export failed", e, stack);
      return "Error: $e";
    }
  }

  // --- 2. SELECT FOLDER (Using System Picker) ---
  static Future<String?> exportToSelectedFolder(BuildContext context) async {
    try {
      AppLogger.info("DatabaseIO: Opening system picker for manual export.");
      final dbPath = await getDatabasesPath();
      final File dbFile = File(join(dbPath, dbName));

      final backupName = FileNaming.generateBackupName();
      final bytes = await dbFile.readAsBytes();
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context).saveBuffetBackup,
        fileName: backupName,
        bytes: bytes,
      );

      if (outputFile != null) {
        int size = bytes.length;
        if (!Platform.isAndroid) {
          try {
            size = await File(outputFile).length();
          } catch (_) {}
        }
        AppLogger.info("DatabaseIO: Manual export SUCCESSFUL to $outputFile (${(size / 1024).toStringAsFixed(2)} KB)");
      } else {
        AppLogger.debug("DatabaseIO: Manual export CANCELLED by user.");
      }

      return outputFile;
    } catch (e, stack) {
      AppLogger.error("DatabaseIO: Manual export failed", e, stack);
      return "Error: $e";
    }
  }

  // --- 3. SHARE FILE ---
  static Future<String?> shareDatabase(BuildContext context) async {
    try {
      AppLogger.info("DatabaseIO: Preparing database for native sharing.");
      final dbPath = await getDatabasesPath();
      final File dbFile = File(join(dbPath, dbName));

      if (!await dbFile.exists()) {
        AppLogger.error("DatabaseIO: Share failed - DB file missing.");
        return "Error: DB not found";
      }

      await Share.shareXFiles([
        XFile(dbFile.path, name: FileNaming.generateBackupName()),
      ], text: 'Buffet POS Backup');

      AppLogger.info("DatabaseIO: Share sheet opened successfully.");
      return "Shared";
    } catch (e, stack) {
      AppLogger.error("DatabaseIO: Share operation failed", e, stack);
      return "Error: $e";
    }
  }

  static Future<bool> importDatabase(BuildContext context) async {
    try {
      // LEVEL: Warning - This overwrites everything
      AppLogger.warning(
        "DatabaseIO: User initiated database IMPORT. Data will be overwritten.",
      );

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        AppLogger.debug("DatabaseIO: Import cancelled - No file selected.");
        return false;
      }

      File backupFile = File(result.files.single.path!);
      AppLogger.info(
        "DatabaseIO: Importing backup from ${backupFile.path} (${result.files.single.size} bytes)",
      );

      if (!backupFile.path.endsWith('.db')) {
        AppLogger.warning(
          "DatabaseIO: Import REJECTED - Invalid file extension: ${backupFile.path}",
        );
        Toaster.show(
          AppLocalizations.of(
            context,
          ).importError(AppLocalizations.of(context).invalidFileType),
          isError: true,
        );
        return false;
      }

      final dbPath = await getDatabasesPath();
      final String path = join(dbPath, dbName);

      AppLogger.debug("DatabaseIO: Closing active DB connections for safe overwrite...");
      final database = await openDatabase(path);
      await database.close();

      await backupFile.copy(path);
      AppLogger.info(
        "DatabaseIO: Import SUCCESSFUL. Local database replaced with backup.",
      );

      return true;
    } catch (e, stack) {
      AppLogger.error("DatabaseIO: Critical failure during import", e, stack);
      Toaster.show(AppLocalizations.of(context).importError(e.toString()));
      return false;
    }
  }

  static Future<bool> resetDatabase(BuildContext context) async {
    try {
      // LEVEL: Warning - Highly destructive
      AppLogger.warning("DatabaseIO: User requested a TOTAL DATABASE RESET.");

      final dbPath = await getDatabasesPath();
      final String path = join(dbPath, dbName);

      AppLogger.debug("DatabaseIO: Forcing DB connection close before deletion.");
      final database = await openDatabase(path);
      await database.close();

      final File dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
        AppLogger.info(
          "DatabaseIO: Reset SUCCESSFUL. Database file deleted from storage.",
        );
      } else {
        AppLogger.warning(
          "DatabaseIO: Reset attempted but no database file found to delete.",
        );
      }
      return true;
    } catch (e, stack) {
      AppLogger.error("DatabaseIO: Critical failure during DB reset", e, stack);
      Toaster.show(AppLocalizations.of(context).resetError(e.toString()));
      return false;
    }
  }
}
