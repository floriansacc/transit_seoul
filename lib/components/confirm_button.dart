import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.description,
    required this.onTap,
    this.verticalPaddingModifier,
    this.horizontalPaddingModifier,
    this.height,
  });

  final String description;
  final VoidCallback onTap;
  final double? verticalPaddingModifier;
  final double? horizontalPaddingModifier;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPaddingModifier ?? 0,
        horizontal: horizontalPaddingModifier ?? 0,
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primaryContainer,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
