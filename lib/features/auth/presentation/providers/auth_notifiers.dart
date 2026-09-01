// lib/features/auth/presentation/providers/auth_notifiers.dart

import 'dart:async';

import 'package:buffet_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buffet_app/core/utils/app_logger.dart'; //
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/generated/l10n.dart';

// 1. The Provider
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});

// 2. The Notifier (The "Brain")
class AuthNotifier extends AsyncNotifier<bool> {
  bool _hasAuthenticatedInSession = false;
  bool _isCurrentlyAuthenticating = false;

  bool get isSessionVerified => _hasAuthenticatedInSession;

  @override
  FutureOr<bool> build() {
    AppLogger.debug(
      "AuthNotifier: Initialized (Session Verified: $_hasAuthenticatedInSession)",
    ); //
    return false;
  }

  Future<bool> authenticateUser(BuildContext context) async {
    if (_isCurrentlyAuthenticating) {
      AppLogger.warning("AuthNotifier: Authentication already in progress. Ignoring duplicate call.");
      return false;
    }

    _isCurrentlyAuthenticating = true;

    try {
      // Level: Info - Tracking the start of a security-sensitive action
      AppLogger.info("AuthNotifier: Starting user authentication process."); //
      state = const AsyncLoading();

      final repository = ref.read(authRepositoryProvider);
      final result = await repository.authenticate(context);

      return result.fold(
        (failure) {
          // Level: Warning - Log that the attempt failed but it wasn't a system crash
          AppLogger.warning(
            "AuthNotifier: Authentication FAILED. Message: ${failure.errMessage}",
          ); //

          state = AsyncError(failure.errMessage, StackTrace.current);
          Toaster.show(failure.errMessage, isError: true);
          return false;
        },
        (isSuccess) {
          state = AsyncData(isSuccess);

          if (isSuccess) {
            _hasAuthenticatedInSession = true;
            // Level: Info - Critical for verifying the "Session Lock" logic is working
            AppLogger.info(
              "AuthNotifier: Authentication SUCCESSFUL. Session flag set to true.",
            ); //
            Toaster.show(AppLocalizations.of(context).identityVerified);
          } else {
            // Level: Info - User likely pressed 'Cancel' on the biometric popup
            AppLogger.info(
              "AuthNotifier: Authentication result was false (User cancelled).",
            ); //
          }

          return isSuccess;
        },
      );
    } finally {
      _isCurrentlyAuthenticating = false;
    }
  }

  /// Optional: Use this to log when a user logs out or session is cleared
  void resetSession() {
    AppLogger.info("AuthNotifier: Manual session reset requested."); //
    _hasAuthenticatedInSession = false;
    state = const AsyncData(false);
  }
}
