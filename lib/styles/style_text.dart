import 'package:transit_seoul/enums/color_type.dart';
import 'package:flutter/material.dart';

class StyleText {
  static Color getColorContainer(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
  }) =>
      switch (colorType) {
        ColorType.primary => Theme.of(context).colorScheme.primaryContainer,
        ColorType.secondary => Theme.of(context).colorScheme.secondaryContainer,
        ColorType.tertiary => Theme.of(context).colorScheme.tertiaryContainer,
        ColorType.error => Theme.of(context).colorScheme.errorContainer,
        _ => color ?? Theme.of(context).colorScheme.primaryContainer,
      };

  static Color getColorOnContainer(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
  }) =>
      switch (colorType) {
        ColorType.primary => Theme.of(context).colorScheme.onPrimaryContainer,
        ColorType.secondary =>
          Theme.of(context).colorScheme.onSecondaryContainer,
        ColorType.tertiary => Theme.of(context).colorScheme.onTertiaryContainer,
        ColorType.error => Theme.of(context).colorScheme.onErrorContainer,
        _ => color ?? Theme.of(context).colorScheme.onPrimaryContainer,
      };

  static TextStyle? headlineMedium(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? headlineSmall(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? titleMedium(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? titleLarge(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? bodyMedium(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? bodyLarge(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }

  static TextStyle? labelSmall(
    BuildContext context, {
    ColorType? colorType,
    Color? color,
    FontWeight? fontWeight,
  }) {
    assert(
      colorType == null || color == null,
      'cannot specify both colorType and color',
    );
    return Theme.of(context).textTheme.labelSmall?.copyWith(
          color:
              getColorOnContainer(context, color: color, colorType: colorType),
          fontWeight: fontWeight,
        );
  }
}
