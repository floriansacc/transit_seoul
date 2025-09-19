import 'package:flutter/material.dart';

class RoundedPicture extends StatelessWidget {
  const RoundedPicture({
    super.key,
    this.size = 80,
    required this.imageUrl,
    this.heroTag,
  });

  final double size;
  final String imageUrl;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: _content(),
      );
    }

    return _content();
  }

  Container _content() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: SizedBox(
        height: size,
        width: size,
        child: Image.network(
          imageUrl,
        ),
      ),
    );
  }
}
