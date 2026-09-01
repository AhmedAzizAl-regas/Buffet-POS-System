import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // Shortcuts for colors
  Color get primaryColor => colorScheme.primary;
  Color get surfaceColor => colorScheme.surface;
}