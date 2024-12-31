import 'package:bus_app/components/map_component.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MapComponent(),
    );
  }
}
