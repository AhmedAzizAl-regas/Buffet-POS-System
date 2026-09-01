import 'package:buffet_app/core/utils/app_logger.dart'; //
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/repositories/local_auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Provides the raw plugin instance
final localAuthenticationProvider = Provider<LocalAuthentication>((ref) {
  // Level: Debug - Confirms the low-level plugin is ready
  AppLogger.debug("AuthDependency: Instantiating LocalAuthentication plugin."); //
  return LocalAuthentication();
});

// Provides the Clean Architecture Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Level: Info - Essential for confirming the Auth layer is wired up
  AppLogger.info("AuthDependency: Initializing AuthRepository implementation."); //

  final authInstance = ref.watch(localAuthenticationProvider);

  try {
    final repository = LocalAuthRepositoryImpl(authInstance);
    AppLogger.debug("AuthDependency: LocalAuthRepositoryImpl successfully created."); //
    return repository;
  } catch (e, stack) {
    // Level: Error - If the constructor itself fails
    AppLogger.error("AuthDependency: Failed to initialize AuthRepository", e, stack); //
    rethrow;
  }
});
