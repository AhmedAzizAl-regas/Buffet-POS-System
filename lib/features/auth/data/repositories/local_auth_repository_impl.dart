import 'package:buffet_app/core/errors/failures.dart';
import 'package:buffet_app/core/utils/app_logger.dart'; //
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

import '../../../../generated/l10n.dart';
import '../../domain/repositories/auth_repository.dart';

class LocalAuthRepositoryImpl implements AuthRepository {
  final LocalAuthentication _auth;

  LocalAuthRepositoryImpl(this._auth);

  @override
  Future<Either<Failure, bool>> authenticate(BuildContext context) async {
    try {
      AppLogger.info("Auth: Triggering native authentication prompt directly."); //

      final bool didAuthenticate = await _auth.authenticate(
        persistAcrossBackgrounding: true,
        sensitiveTransaction: false,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: AppLocalizations.of(context).biometricAuthentication,
            signInHint: AppLocalizations.of(context).verifyIdentity,
            cancelButton: AppLocalizations.of(context).cancel,
          ),
          IOSAuthMessages(
            localizedFallbackTitle: AppLocalizations.of(context).authErrorMessage,
            cancelButton: AppLocalizations.of(context).cancel,
            goToSettingsButton: AppLocalizations.of(context).settings,
            goToSettingsDescription: AppLocalizations.of(context).pleaseSetUpBiometrics,
            lockOut: AppLocalizations.of(context).tooManyAttemptsLockout,
          ),
        ],
        localizedReason: AppLocalizations.of(context).pleaseAuthenticateToConfirm,
      );

      if (didAuthenticate) {
        AppLogger.info("Auth: Authentication SUCCESSFUL."); //
      } else {
        AppLogger.warning("Auth: Authentication FAILED or user backed out."); //
      }

      return Right(didAuthenticate);
    } on PlatformException catch (e) {
      // Level: Error - Specific hardware/OS level failures
      AppLogger.error(
        "Auth: PlatformException caught during authentication (Code: ${e.code})",
        e,
      ); //

      switch (e.code) {
        case 'NotAvailable':
          return Left(
            AuthenticationFailure(AppLocalizations.of(context).biometricsNotAvailable),
          );
        case 'NotEnrolled':
          return Left(
            AuthenticationFailure(AppLocalizations.of(context).noBiometricsRegistered),
          );
        case 'LockedOut':
          return Left(
            AuthenticationFailure(AppLocalizations.of(context).tooManyAttemptsRetry),
          );
        case 'PermanentlyLockedOut':
          return Left(
            AuthenticationFailure(
              AppLocalizations.of(context).biometricsDisabledUsePasscode,
            ),
          );
        case 'OtherOperatingSystem':
          return Left(AuthenticationFailure(AppLocalizations.of(context).osNotSupported));
        default:
          return Right(false);
      }
    } on LocalAuthException catch (e) {
      // Level: Debug/Info - Mostly handles flow-based cancellations
      AppLogger.debug("Auth: LocalAuthException caught (Code: ${e.code})"); //

      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
          AppLogger.info("Auth: User or System cancelled the prompt."); //
          return Right(false);
        case LocalAuthExceptionCode.noCredentialsSet:
          AppLogger.warning("Auth: No credentials set on device."); //
          return Right(true);
        default:
          AppLogger.error("Auth: Unhandled LocalAuthException", e); //
          return Left(
            AuthenticationFailure(
              AppLocalizations.of(context).errorOccurred(e.toString()),
            ),
          );
      }
    } catch (e, stack) {
      // Level: Error - Generic unexpected crashes
      AppLogger.error("Auth: UNEXPECTED FAILURE in LocalAuthRepository", e, stack); //
      return Left(
        AuthenticationFailure(AppLocalizations.of(context).errorOccurred(e.toString())),
      );
    }
  }
}
