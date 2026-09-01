// lib/core/utils/permission_helper.dart

import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Requests the appropriate storage permissions based on the Android version.
  ///
  /// Returns [true] if permission is granted or if the platform is not Android.
  static Future<bool> requestStoragePermission() async {
    // Storage permissions are no longer requested because the app has migrated to
    // using the Storage Access Framework (SAF) and external app-specific directories,
    // neither of which require any permissions on Android.
    AppLogger.debug("PermissionHelper: Storage permission bypassed (always true).");
    return true;
  }

  // Use this if they click "Export" and permission was permanently denied
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
