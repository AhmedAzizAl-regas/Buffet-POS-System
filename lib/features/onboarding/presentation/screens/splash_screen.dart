import 'package:buffet_app/core/database/database_service.dart';
import 'package:buffet_app/core/providers/common_providers.dart';
import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.forward();
      _initializeCoreServices();
    });
  }

  Future<void> _initializeCoreServices() async {
    try {
      final dbService = ref.read(databaseServiceProvider);
      final onboardingDone = ref.watch(
        configProvider.select((c) => c['onboarding_done'] == 'true'),
      );
      final authGatewayDone = ref.watch(
        configProvider.select((c) => c['auth_gateway_done'] == 'true'),
      );

      await Future.wait([
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
        ref.read(appVersionProvider.future),
        dbService.init(),
      ]);

      AppLogger.debug("SplashScreen: Warming up background services...");

      // Branded splash delay
      await Future.delayed(const Duration(milliseconds: 1900));

      if (mounted) {
        AppLogger.info(
          "SplashScreen: Initialization complete. Navigating...",
        );
        if (!onboardingDone) {
          context.go(AppRoutes.onboarding.path);
        } else if (!authGatewayDone) {
          context.go(AppRoutes.languageGateway.path);
        } else {
          context.go(AppRoutes.pos.path);
        }
      }
    } catch (e, stack) {
      debugPrint("Initialization error: $e");
      AppLogger.error("Initialization error in SplashScreen", e, stack);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final versionAsync = ref.watch(appVersionProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, context.primaryColor.withAlpha(20)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.primaryColor.withAlpha(30),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.primaryColor.withAlpha(150),
                    ),
                  ),
                  const SizedBox(height: 16),
                  versionAsync.when(
                    data: (version) => Text(
                      AppLocalizations.of(context).appVersionVersion(version),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => Center(
                      child: Text(
                        AppLocalizations.of(context).versionUnknown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
