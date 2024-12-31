import 'package:bus_app/enums/color_type.dart';
import 'package:flutter/material.dart';

class StyleText {
  static getColor(BuildContext context, {ColorType? colorType, Color? color}) =>
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
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
          color: getColor(context, color: color, colorType: colorType),
          fontWeight: fontWeight ?? FontWeight.w400,
        );
  }
}
