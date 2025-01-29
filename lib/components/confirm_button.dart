import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.description,
    this.textStyle,
    required this.onTap,
    this.verticalPaddingModifier,
    this.horizontalPaddingModifier,
    this.color,
    this.height,
    this.width,
    this.borderSide = BorderSide.none,
  });

  final String description;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  final double? verticalPaddingModifier;
  final double? horizontalPaddingModifier;
  final Color? color;
  final double? height;
  final double? width;
  final BorderSide borderSide;

  @override
  Widget build(BuildContext context) {
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
              color ?? Theme.of(context).colorScheme.primaryContainer,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: borderSide,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          child: Text(
            description,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
