import 'package:bus_app/router/route_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

class PublicMethod {
  static Future<void> preferenceController() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
  }

  static Future goPage(
    BuildContext context,
    RouteEnum path, {
    Object? extra,
    String? params,
  }) async {
    GoRouter.of(context).go(path.path, extra: extra);
  }

  static Future pushPage(
    BuildContext context,
    RouteEnum path, {
    Object? extra,
    String? params,
  }) async {
    GoRouter.of(context).push(path.path, extra: extra);
  }
}
