import 'package:intl/intl.dart';

class FileNaming {
  ///Generate Database filename with this format <br/> DB\_BUFFET\_20260408114502.db
  ///
  static String generateBackupName() {
    final now = DateTime.now();

    // Format: 20260408_114530 (YearMonthDay_HourMinSec)
    // No symbols = maximum compatibility
    final timestamp = DateFormat('yyyyMMddHHmmss', 'en').format(now);

    return 'DB_BUFFET_BACKUP_$timestamp.db';
  }

  /// Generates a filename for exports with this format <br/> BUFFET\_[moduleName]\_202604081130.csv
  ///
  ///
  ///
  /// - [moduleName]: The feature name without file's extension  (e.g., 'products', 'orders').
  static String generateFileName(String moduleName) {
    // 1. Get the current timestamp
    final now = DateTime.now();

    final timestamp = DateFormat('yyyyMMddHHmmss', 'en').format(now);

    // 4. Combine into a clean, uppercase string
    return 'BUFFET_${moduleName.toUpperCase()}_$timestamp.csv';
  }
}
