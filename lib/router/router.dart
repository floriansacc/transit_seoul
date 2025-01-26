import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit_seoul/pages/bus/bus_info_page.dart';
import 'package:transit_seoul/pages/bus/bus_page.dart';
import 'package:transit_seoul/pages/map/map_page.dart';
import 'package:transit_seoul/pages/metro/metro_page.dart';
import 'package:transit_seoul/pages/settings/settings_page.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';

GoRouter get router => _router;

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _busNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'busNavigatorKey');
final GlobalKey<NavigatorState> _metroNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'metroNavigatorKey');
final GlobalKey<NavigatorState> _mapNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'mapNavigatorKey');

final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteEnum.home.path,
  routes: [
    StatefulShellRoute(
      parentNavigatorKey: navigatorKey,
      navigatorContainerBuilder: (context, navigationShell, children) {
        return HomePage(
          navigationShell: navigationShell,
          children: children,
        );
      },

      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return navigationShell;
      },
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
      branches: [
        StatefulShellBranch(
          navigatorKey: _busNavigatorKey,
          routes: [
            GoRoute(
              path: RouteEnum.home.path,
              pageBuilder: (context, state) {
                Map<String, dynamic>? extra =
                    state.extra as Map<String, dynamic>?;

                return CustomTransitionPage(
                  child: BusPage(
                    controller: extra?['controller'],
                  ),
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
        StatefulShellBranch(
          navigatorKey: _metroNavigatorKey,
          routes: [
            GoRoute(
              path: RouteEnum.metro.path,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  child: MetroPage(),
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
        StatefulShellBranch(
          navigatorKey: _mapNavigatorKey,
          routes: [
            GoRoute(
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
      ],
    ),
    GoRoute(
      path: RouteEnum.settings.path,
      pageBuilder: (context, state) {
        return CupertinoPage(child: SettingsPage());
      },
    ),
    GoRoute(
      path: RouteEnum.busInfo.path,
      pageBuilder: (context, state) {
        Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        return CupertinoPage(
          child: BlocProvider(
            create: (context) => MapPointCubit(),
            child: BusInfoPage(
              heroTag: extra?['heroTag'],
            ),
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
