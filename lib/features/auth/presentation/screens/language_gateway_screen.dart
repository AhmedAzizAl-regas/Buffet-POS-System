import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/providers/locale_provider.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LanguageGatewayScreen extends ConsumerWidget {
  const LanguageGatewayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isArabic = currentLocale.languageCode == 'ar';
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    void selectLanguage(String lang) {
      ref.read(configProvider.notifier).setConfig('language', lang);
    }

    void handleSkip() {
      ref.read(configProvider.notifier).setConfig('auth_gateway_done', 'true');
      context.go(AppRoutes.pos.path);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo & App Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withAlpha(30),
                            blurRadius: 30,
                            spreadRadius: 2,
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
                    const SizedBox(height: 24),
                    Text(
                      l10n.welcomeToBuffet,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectLanguage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Language Cards
              Row(
                children: [
                  // Arabic Card
                  Expanded(
                    child: InkWell(
                      onTap: () => selectLanguage('ar'),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: isArabic ? theme.primaryColor.withAlpha(15) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isArabic ? theme.primaryColor : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: isArabic
                              ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withAlpha(20),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "🇸🇦",
                              style: TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.arabic,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isArabic ? theme.primaryColor : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // English Card
                  Expanded(
                    child: InkWell(
                      onTap: () => selectLanguage('en'),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: !isArabic ? theme.primaryColor.withAlpha(15) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: !isArabic ? theme.primaryColor : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: !isArabic
                              ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withAlpha(20),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "🇬🇧",
                              style: TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.english,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: !isArabic ? theme.primaryColor : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Action Buttons
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.login.path),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(l10n.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push(AppRoutes.register.path),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: theme.primaryColor, width: 1.5),
                ),
                child: Text(l10n.signUp),
              ),

              const SizedBox(height: 24),

              // Skip Button
              TextButton(
                onPressed: handleSkip,
                child: Text(
                  l10n.skip,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
