import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_bar_general.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGeneral(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Bus',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
        ],
        elevation: 0,
        animationDuration: Duration(milliseconds: 300),
        onDestinationSelected: (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
          setState(() {});
        },
        selectedIndex: widget.child.currentIndex,
      ),
    );
  }
}
