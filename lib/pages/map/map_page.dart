import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('titleLarge', style: Theme.of(context).textTheme.titleLarge),
              Text(
                'titleMedium',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text('titleSmall', style: Theme.of(context).textTheme.titleSmall),
            ]),
          ),
        ),
      ],
    );
  }
}
