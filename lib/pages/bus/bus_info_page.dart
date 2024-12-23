import 'package:flutter/material.dart';

class BusInfoPage extends StatelessWidget {
  const BusInfoPage({
    super.key,
    this.heroTag,
  });

  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bus Info',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Hero(
        tag: heroTag ?? '',
        child: Image.asset('assets/images/test_1.avif'),
      ),
    );
  }
}
