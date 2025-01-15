import 'package:transit_seoul/components/animated_page_wrapper.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_bar_general.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController controllerBus;

  @override
  void initState() {
    super.initState();
    controllerBus = ScrollController(keepScrollOffset: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGeneral(),
      body: AnimatedPageWrapperOpacity(
        currentIndex: widget.navigationShell.currentIndex,
        children: widget.children,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Bus',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.subway),
            icon: Icon(Icons.subway_outlined),
            label: 'Metro',
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
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );

          if (index == 0) {
            GoRouter.of(context)
                .go(RouteEnum.home.path, extra: {'controller': controllerBus});
            if (index == widget.navigationShell.currentIndex) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controllerBus.animateTo(
                  0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              });
            }
          }

          setState(() {});
        },
        selectedIndex: widget.navigationShell.currentIndex,
      ),
    );
  }
}
