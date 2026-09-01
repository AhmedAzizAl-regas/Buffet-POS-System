import 'package:flutter/material.dart';

class AppTheme {
  // --- BRAND COLORS ---
  static const Color primaryColor = Colors.orange;

  static const Color scaffoldBg = Colors.white;
  static final Color greyLight = Colors.grey.shade50;
  static final Color greyBorder = Colors.grey.shade200;

  /// Returns the theme based on the current [locale].
  /// This handles font switching and RTL spacing automatically.
  static ThemeData getTheme(Locale locale, {bool isDark = false}) {
    final bool isArabic = locale.languageCode == 'ar';

    // Arabic text often needs to be 1-2 points larger to be as readable as Latin
    final double fontSizeFactor = isArabic ? 1.1 : 1.0;

    final Color scaffoldBgColor = isDark ? const Color(0xFF121212) : scaffoldBg;
    final Color greyLightColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50;
    final Color greyBorderColor = isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color textColor87 = isDark ? Colors.white.withOpacity(0.87) : Colors.black87;
    final Color dialogBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBgColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        splashColor: Colors.white.withAlpha(30),
      ),

      // --- 1. DYNAMIC FONTS ---
      fontFamily: isArabic ? 'Tajawal' : 'Roboto',
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: dialogBgColor,
      ),
      // --- 2. COLOR SCHEME ---
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: Colors.white,
        surface: scaffoldBgColor,
        onSurface: textColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      // --- 3. TYPOGRAPHY ---
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          height: isArabic ? 1.4 : 1.2,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20 * fontSizeFactor,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14 * fontSizeFactor,
          color: textColor87,
        ),
      ),
      // --- 10. CHIPS (ChoiceChip & ActionChip) ---
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
        selectedColor: primaryColor,
        disabledColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,

        // The checkmark animation and color
        checkmarkColor: Colors.white,
        showCheckmark: true, // Set to true to match your Catalog animation
        // Padding and spacing to match your 60px height container
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),

        // Border and Shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),

        // Text Styles using your dynamic factors
        labelStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          fontSize: 14 * fontSizeFactor,
          color: textColor,
          fontWeight: FontWeight.normal,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          fontSize: 14 * fontSizeFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Removes the default Material 3 border if you want a flatter look
        side: BorderSide.none,
      ),
      // --- 4. RADIO & SELECTION ---
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        }),
      ),

      // --- 5. APP BAR ---
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBgColor,
        foregroundColor: isDark ? Colors.grey.shade300 : Colors.blueGrey,

        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          color: textColor,
          fontSize: 20 * fontSizeFactor,
          fontWeight: FontWeight.bold,
        ),
      ),

      // --- 6. DIALOG THEME ---
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          fontSize: 18 * fontSizeFactor,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),

      // --- 7. BUTTONS ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          textStyle: TextStyle(
            fontFamily: isArabic ? 'Tajawal' : 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 16 * fontSizeFactor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          elevation: WidgetStateProperty.all(0),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(0, 54),
        ),
      ),

      // --- 8. INPUT FIELDS ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: greyLightColor,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: greyBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.blueGrey,
          fontWeight: FontWeight.w500,
        ),
      ),

      // --- 9. CARDS & LIST TILES ---
      cardTheme: CardThemeData(
        elevation: 0,
        color: greyLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: greyBorderColor),
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: primaryColor,
        textColor: textColor,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      ),

      // --- TAB BAR THEME ---
      tabBarTheme: TabBarThemeData(
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: primaryColor,
        labelStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 14 * fontSizeFactor,
        ),
        unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        unselectedLabelStyle: TextStyle(
          fontFamily: isArabic ? 'Tajawal' : 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14 * fontSizeFactor,
        ),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryColor.withAlpha(20);
          }
          return null;
        }),
      ),
    );
  }
}
