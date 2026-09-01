// lib/core/providers/common_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Provider to fetch the app version once during the app lifecycle
final appVersionProvider = FutureProvider<String>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();

  // Return format: "1.0.4 (12)"
  return packageInfo.version;
});

// In common_providers.dart
final adminTapProvider = StateProvider<int>((ref) => 0);
