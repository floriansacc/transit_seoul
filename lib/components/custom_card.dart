import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.onTap,
    required this.content,
    this.bgColor,
  });

  final VoidCallback onTap;
  final Widget content;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: bgColor ?? Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(15, 0, 0, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
