import 'package:bus_app/pages/bus/bus_info_page.dart';
import 'package:bus_app/pages/bus/bus_page.dart';
import 'package:bus_app/pages/map/map_page.dart';
import 'package:bus_app/pages/settings/settings_page.dart';
import 'package:bus_app/router/route_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';

GoRouter get router => _router;

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _busNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'busNavigatorKey');
final GlobalKey<NavigatorState> _mapNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'mapNavigatorKey');

final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteEnum.home.path,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      // navigatorContainerBuilder: (context, navigationShell, children) {
      //   return HomePage(
      //     navigationShell: navigationShell,
      //     children: children,
      //   );
      // },
      builder: (context, state, child) {
        return HomePage(child: child);
      },

      // builder: (
      //   BuildContext context,
      //   GoRouterState state,
      //   StatefulNavigationShell navigationShell,
      // ) {
      //   return navigationShell;
      // },
      // pageBuilder: (
      //   BuildContext context,
      //   GoRouterState state,
      //   StatefulNavigationShell navigationShell,
      // ) {
      //   return getPage(
      //     state: state,
      //     child: HomePage(
      //       child: navigationShell,
      //     ),
      //   );
      // },
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteEnum.home.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: BusPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: RouteEnum.map.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: MapPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteEnum.settings.path,
      pageBuilder: (context, state) {
        return CupertinoPage(child: SettingsPage());
      },
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteEnum.busInfo.path,
      pageBuilder: (context, state) {
        Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        return CupertinoPage(
          child: BusInfoPage(
            heroTag: extra?['heroTag'],
          ),
        );
      },
    ),
  ],
);

Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}

Widget fadeTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}
