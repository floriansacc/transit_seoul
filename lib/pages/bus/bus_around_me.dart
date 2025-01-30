import 'package:flutter/material.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusAroundMe extends StatelessWidget {
  const BusAroundMe({
    super.key,
    this.heroTag,
  });

  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 주변 버스',
          style: StyleText.bodyLarge(context),
        ),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
  }
}
