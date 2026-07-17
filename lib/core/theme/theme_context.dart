import 'package:flutter/material.dart';
import 'theme_extensions.dart';

class AppThemeContainer {
  final ThemeData data;
  final AppColorsExtension colors;
  final AppSpacingExtension spacing;
  final AppRadiusExtension radius;
  final AppShadowsExtension shadows;
  final TextTheme text;

  AppThemeContainer({
    required this.data,
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.shadows,
    required this.text,
  });
}

extension ThemeContext on BuildContext {
  AppThemeContainer get theme {
    final ThemeData themeData = Theme.of(this);
    final AppColorsExtension? colorsExt = themeData
        .extension<AppColorsExtension>();
    final AppSpacingExtension? spacingExt = themeData
        .extension<AppSpacingExtension>();
    final AppRadiusExtension? radiusExt = themeData
        .extension<AppRadiusExtension>();
    final AppShadowsExtension? shadowsExt = themeData
        .extension<AppShadowsExtension>();

    assert(colorsExt != null, 'AppColorsExtension not found in current theme.');
    assert(
      spacingExt != null,
      'AppSpacingExtension not found in current theme.',
    );
    assert(radiusExt != null, 'AppRadiusExtension not found in current theme.');
    assert(
      shadowsExt != null,
      'AppShadowsExtension not found in current theme.',
    );

    return AppThemeContainer(
      data: themeData,
      colors: colorsExt!,
      spacing: spacingExt!,
      radius: radiusExt!,
      shadows: shadowsExt!,
      text: themeData.textTheme,
    );
  }

  // Handy direct shortcuts
  AppColorsExtension get colors => theme.colors;
  AppSpacingExtension get spacing => theme.spacing;
  AppRadiusExtension get radius => theme.radius;
  AppShadowsExtension get shadows => theme.shadows;
  TextTheme get text => theme.text;
}
