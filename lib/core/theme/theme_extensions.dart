import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color surface;
  final Color surfaceContainerLow;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color error;
  final Color outline;
  final Color outlineVariant;
  final Color secondary;
  final Color background;
  final Color success;
  final Color warning;
  final Color gold;
  final Color silver;
  final Color bronze;
  final Color cardBackground;
  final Color divider;

  const AppColorsExtension({
    required this.primary,
    required this.surface,
    required this.surfaceContainerLow,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.error,
    required this.outline,
    required this.outlineVariant,
    required this.secondary,
    required this.background,
    required this.success,
    required this.warning,
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.cardBackground,
    required this.divider,
  });

  @override
  AppColorsExtension copyWith({
    final Color? primary,
    final Color? surface,
    final Color? surfaceContainerLow,
    final Color? surfaceContainerHighest,
    final Color? onSurface,
    final Color? onSurfaceVariant,
    final Color? error,
    final Color? outline,
    final Color? outlineVariant,
    final Color? secondary,
    final Color? background,
    final Color? success,
    final Color? warning,
    final Color? gold,
    final Color? silver,
    final Color? bronze,
    final Color? cardBackground,
    final Color? divider,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      surface: surface ?? this.surface,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      bronze: bronze ?? this.bronze,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColorsExtension lerp(
    final ThemeExtension<AppColorsExtension>? other,
    final double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      silver: Color.lerp(silver, other.silver, t)!,
      bronze: Color.lerp(bronze, other.bronze, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  final double xs;
  final double sm;
  final double inputGap;
  final double cardPadding;
  final double md;
  final double pagePadding;
  final double lg;
  final double xl;
  final double xxl;

  const AppSpacingExtension({
    required this.xs,
    required this.sm,
    required this.inputGap,
    required this.cardPadding,
    required this.md,
    required this.pagePadding,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  @override
  AppSpacingExtension copyWith({
    final double? xs,
    final double? sm,
    final double? inputGap,
    final double? cardPadding,
    final double? md,
    final double? pagePadding,
    final double? lg,
    final double? xl,
    final double? xxl,
  }) {
    return AppSpacingExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      inputGap: inputGap ?? this.inputGap,
      cardPadding: cardPadding ?? this.cardPadding,
      md: md ?? this.md,
      pagePadding: pagePadding ?? this.pagePadding,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacingExtension lerp(
    final ThemeExtension<AppSpacingExtension>? other,
    final double t,
  ) {
    if (other is! AppSpacingExtension) {
      return this;
    }
    return AppSpacingExtension(
      xs: _lerpDouble(xs, other.xs, t),
      sm: _lerpDouble(sm, other.sm, t),
      inputGap: _lerpDouble(inputGap, other.inputGap, t),
      cardPadding: _lerpDouble(cardPadding, other.cardPadding, t),
      md: _lerpDouble(md, other.md, t),
      pagePadding: _lerpDouble(pagePadding, other.pagePadding, t),
      lg: _lerpDouble(lg, other.lg, t),
      xl: _lerpDouble(xl, other.xl, t),
      xxl: _lerpDouble(xxl, other.xxl, t),
    );
  }

  double _lerpDouble(final double a, final double b, final double t) {
    return a + (b - a) * t;
  }
}

class AppRadiusExtension extends ThemeExtension<AppRadiusExtension> {
  final BorderRadius small;
  final BorderRadius medium;
  final BorderRadius feedItem;
  final BorderRadius card;
  final BorderRadius button;
  final BorderRadius input;
  final BorderRadius large;
  final BorderRadius round;

  const AppRadiusExtension({
    required this.small,
    required this.medium,
    required this.feedItem,
    required this.card,
    required this.button,
    required this.input,
    required this.large,
    required this.round,
  });

  @override
  AppRadiusExtension copyWith({
    final BorderRadius? small,
    final BorderRadius? medium,
    final BorderRadius? feedItem,
    final BorderRadius? card,
    final BorderRadius? button,
    final BorderRadius? input,
    final BorderRadius? large,
    final BorderRadius? round,
  }) {
    return AppRadiusExtension(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      feedItem: feedItem ?? this.feedItem,
      card: card ?? this.card,
      button: button ?? this.button,
      input: input ?? this.input,
      large: large ?? this.large,
      round: round ?? this.round,
    );
  }

  @override
  AppRadiusExtension lerp(
    final ThemeExtension<AppRadiusExtension>? other,
    final double t,
  ) {
    if (other is! AppRadiusExtension) {
      return this;
    }
    return AppRadiusExtension(
      small: BorderRadius.lerp(small, other.small, t)!,
      medium: BorderRadius.lerp(medium, other.medium, t)!,
      feedItem: BorderRadius.lerp(feedItem, other.feedItem, t)!,
      card: BorderRadius.lerp(card, other.card, t)!,
      button: BorderRadius.lerp(button, other.button, t)!,
      input: BorderRadius.lerp(input, other.input, t)!,
      large: BorderRadius.lerp(large, other.large, t)!,
      round: BorderRadius.lerp(round, other.round, t)!,
    );
  }
}

class AppShadowsExtension extends ThemeExtension<AppShadowsExtension> {
  final List<BoxShadow> light;
  final List<BoxShadow> medium;
  final List<BoxShadow> dark;

  const AppShadowsExtension({
    required this.light,
    required this.medium,
    required this.dark,
  });

  @override
  AppShadowsExtension copyWith({
    final List<BoxShadow>? light,
    final List<BoxShadow>? medium,
    final List<BoxShadow>? dark,
  }) {
    return AppShadowsExtension(
      light: light ?? this.light,
      medium: medium ?? this.medium,
      dark: dark ?? this.dark,
    );
  }

  @override
  AppShadowsExtension lerp(
    final ThemeExtension<AppShadowsExtension>? other,
    final double t,
  ) {
    if (other is! AppShadowsExtension) {
      return this;
    }
    return AppShadowsExtension(
      light: BoxShadow.lerpList(light, other.light, t)!,
      medium: BoxShadow.lerpList(medium, other.medium, t)!,
      dark: BoxShadow.lerpList(dark, other.dark, t)!,
    );
  }
}
