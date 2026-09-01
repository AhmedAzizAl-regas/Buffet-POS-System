import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;

extension NumberFormatter on num {
  Widget toPriceWidget(WidgetRef ref, {TextStyle? style, String? overrideSign}) {
    final configs = ref.watch(configProvider);
    final appLang = configs['language'] ?? 'system';
    final isArabic = appLang == 'ar' ||
        (appLang == 'system' && Intl.systemLocale.startsWith('ar'));

    final activeArSign = configs['currency_sign_ar'] ?? configs['currency_sign'] ?? 'assets/icons/sar.svg';
    final activeEnSign = configs['currency_sign_en'] ?? (activeArSign.contains('sar.svg') ? 'SAR' : 'YR');

    final currencySign = overrideSign ?? (isArabic ? activeArSign : activeEnSign);
    final double fontSize = style?.fontSize ?? 14.0;
    final double iconSize = fontSize * 0.85;
    final locale = configs['number_format'] ?? 'en';
    final formatter = NumberFormat.decimalPattern(locale);

    if (this % 1 != 0) {
      // If it has a decimal remainder, force 2 places
      formatter.minimumFractionDigits = 2;
      formatter.maximumFractionDigits = 2;
    } else {
      // If it's a whole number, no decimals
      formatter.minimumFractionDigits = 0;
    }
    String formatted = formatter.format(this);
    // formatted = this % 1 == 0 ? toInt().toString() : toStringAsFixed(2);

    if (locale.startsWith('ar')) {
      formatted = _toArabicDigits(formatted);
    }
    // --- INNER FALLBACK WIDGET ---
    Widget buildSvg(String path, {bool isRetry = false}) {
      return SvgPicture.asset(
        path,
        height: iconSize,
        width: iconSize,
        colorFilter: ColorFilter.mode(style?.color ?? Colors.black, BlendMode.srcIn),
        errorBuilder: (context, error, stackTrace) {
          // If the primary fails, try a "guaranteed" local asset
          if (!isRetry) {
            // OPTIONAL: Silently update the config to a working default
            Future.microtask(
              () => ref
                  .read(configProvider.notifier)
                  .setConfig('currency_sign', 'assets/icons/sar.svg'),
            );

            return buildSvg('assets/icons/sar.svg', isRetry: true);
          }
          // If even the default fails, return the text '$'
          return Text("\$", style: style);
        },
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Forces perfect center alignment
          children: [
            if (currencySign.contains('.svg'))
              Padding(
                // We use a specific padding to nudge the SVG so its
                // "visual center" matches the number's center.
                padding: const EdgeInsets.only(top: 1),
                child: buildSvg(currencySign),
              )
            else
              Text(currencySign, style: style),

            // The gap
            SizedBox(width: (currencySign.contains('sar.svg') ? 6 : 0)),

            // The number
            Text(
              formatted,
              style: style?.copyWith(
                // Forces the text to have no extra "leading" (invisible vertical space)
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats currency with:
  /// 1. Digit Style (123 vs ١٢٣)
  /// 2. Forced Space
  /// 3. Custom Sign ($, YR, etc.)
  String toPrice(WidgetRef ref) {
    final configs = ref.watch(configProvider);
    final locale = configs['number_format'] ?? 'en';
    final appLang = configs['language'] ?? 'system';
    final isArabic = appLang == 'ar' ||
        (appLang == 'system' && Intl.systemLocale.startsWith('ar'));

    final activeArSign = configs['currency_sign_ar'] ?? configs['currency_sign'] ?? 'ريال';
    final activeEnSign = configs['currency_sign_en'] ?? 'YR';

    String currencySign = isArabic ? activeArSign : activeEnSign;
    if (currencySign.contains('.svg')) {
      currencySign = isArabic ? 'ريال' : 'YR';
    }

    // Format the number as a standard string first (e.g., "12.50")
    String formatted = toStringAsFixed(2);

    // If the locale is Arabic, manually swap the digits
    if (locale.startsWith('ar')) {
      formatted = _toArabicDigits(formatted);
    }

    return "$formatted $currencySign";
  }

  String toLocalNum(WidgetRef ref) {
    final locale = ref.watch(configProvider)['number_format'] ?? 'en';
    String formatted = toString();

    if (locale.startsWith('ar')) {
      formatted = _toArabicDigits(formatted);
    }
    return formatted;
  }

  // Internal helper to force digit replacement
  String _toArabicDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }

  /// Formats a simple localized number (quantities)
}

extension DateFormatter on DateTime {
  /// 1. Formats Date (e.g., 25/03/2026)
  String toLocalDate(WidgetRef ref) {
    final configs = ref.watch(configProvider);
    final pattern = configs['date_format'] ?? 'dd/MM/yyyy';
    final locale = configs['number_format'] ?? 'en';

    return DateFormat(pattern, locale).format(this);
  }

  /// 2. Formats Time (e.g., 04:30 PM or ١٦:٣٠)
  String toLocalTime(WidgetRef ref) {
    final configs = ref.watch(configProvider);
    final locale = configs['number_format'] ?? 'en';

    // Get the pattern from config (e.g., 'hh:mm a' for 12hr or 'HH:mm' for 24hr)
    final timePattern = configs['time_format'] ?? 'hh:mm a';

    String formatted = DateFormat(timePattern, locale).format(this);

    // Translate AM/PM if language is Arabic
    final appLang = configs['language'] ?? 'system';
    final isArabic = appLang == 'ar' ||
        (appLang == 'system' && Intl.systemLocale.startsWith('ar'));

    if (isArabic) {
      formatted = formatted
          .replaceAll('AM', 'ص')
          .replaceAll('PM', 'م')
          .replaceAll('am', 'ص')
          .replaceAll('pm', 'م')
          .replaceAll('a.m.', 'ص')
          .replaceAll('p.m.', 'م');
    }

    return formatted;
  }

  /// 3. Formats Both (e.g., 25/03/2026 04:30 PM)
  /// This is the "Best" way because it stays reactive to both settings
  String toLocalDateTime(WidgetRef ref) {
    return "${toLocalDate(ref)} ${toLocalTime(ref)}";
  }
}
