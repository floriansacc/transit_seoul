import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:transit_seoul/enums/color_type.dart';
import 'package:transit_seoul/styles/style_text.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.description,
    this.textStyle,
    this.onTap,
    this.verticalPaddingModifier,
    this.horizontalPaddingModifier,
    this.color,
    this.height,
    this.width,
    this.borderSide = BorderSide.none,
    this.prefixChild,
    this.preset = ConfirmButtonPreset.primary,
  });

  final String description;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final double? verticalPaddingModifier;
  final double? horizontalPaddingModifier;
  final Color? color;
  final double? height;
  final double? width;
  final BorderSide borderSide;
  final Widget? prefixChild;
  final ConfirmButtonPreset preset;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = StyleText.getColorContainer(
      context,
      colorType: switch (preset) {
        ConfirmButtonPreset.primary => ColorType.primary,
        ConfirmButtonPreset.secondary => ColorType.secondary,
        ConfirmButtonPreset.tertiary => ColorType.tertiary,
        ConfirmButtonPreset.error => ColorType.error,
      },
    );

    final Color textColor = StyleText.getColorOnContainer(
      context,
      colorType: switch (preset) {
        ConfirmButtonPreset.primary => ColorType.primary,
        ConfirmButtonPreset.secondary => ColorType.secondary,
        ConfirmButtonPreset.tertiary => ColorType.tertiary,
        ConfirmButtonPreset.error => ColorType.error,
      },
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPaddingModifier ?? 0,
        horizontal: horizontalPaddingModifier ?? 0,
      ),
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              color ?? bgColor,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: borderSide,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          child: Row(
            children: [
              if (prefixChild != null) ...[
                prefixChild!,
                Gap(4),
              ],
              Expanded(
                child: Text(
                  description,
                  style: (textStyle ?? StyleText.bodyMedium(context))?.copyWith(
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ConfirmButtonPreset {
  primary,
  secondary,
  tertiary,
  error;
}
