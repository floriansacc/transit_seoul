import 'package:flutter/material.dart';

class BusPage extends StatelessWidget {
  const BusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('bodyLarge', style: Theme.of(context).textTheme.bodyLarge),
              Text('bodyMedium', style: Theme.of(context).textTheme.bodyMedium),
              Text('bodySmall', style: Theme.of(context).textTheme.bodySmall),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
