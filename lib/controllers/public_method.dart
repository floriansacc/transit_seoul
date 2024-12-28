import 'dart:io';

import 'package:bus_app/router/route_enum.dart';
import 'package:flutter/cupertino.dart';
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

  static Widget nextButtonIosKeyboard(
    BuildContext context, {
    required bool displayCondition,
    required void Function() onTapFuction,
    required String buttonText,
  }) {
    if (Platform.isIOS) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: displayCondition ? 40 : 0,
          color: const Color(0xFFD0D5DC),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onTapFuction,
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  textStyle: WidgetStatePropertyAll(
                    Theme.of(context).textTheme.bodyLarge,
                  ),
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.isNotEmpty) {
                      if (states.first == WidgetState.pressed) {
                        return CupertinoColors.systemBlue.darkHighContrastColor;
                      }
                    }
                    return CupertinoColors.activeBlue;
                  }),
                  backgroundColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
