import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transit_seoul/router/router.dart';

late SharedPreferences prefs;

class PublicMethod {
  static Future<void> preferenceController() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
  }

  static int parseInt(dynamic value) {
    if (value == null) return 0; // Default value for null
    if (value is int) return value; // Return the int directly
    if (value is double) {
      return value.isNaN
          ? 0
          : value.toInt(); // Handle NaN for double and convert to int
    }
    if (value is String) {
      int? parsed = int.tryParse(value);
      if (parsed != null) return parsed;

      // Handle cases where the string might represent a double
      double? parsedDouble = double.tryParse(value);
      return parsedDouble == null || parsedDouble.isNaN
          ? 0
          : parsedDouble.toInt();
    }
    return 0; // Default value for unexpected types
  }

  static double parseDouble(dynamic value) {
    if (value == null) return 0.0; // Default value for null
    if (value is int) return value.toDouble(); // Convert int to double
    if (value is double) {
      return value.isNaN ? 0.0 : value; // Handle NaN for double
    }
    if (value is String) {
      double? parsed = double.tryParse(value);
      return parsed == null || parsed.isNaN
          ? 0.0
          : parsed; // Handle invalid string or NaN
    }
    return 0.0; // Default value for unexpected types
  }

  static Future goPage(
    BuildContext context,
    RouteEnum path, {
    Object? extra,
    String? params,
  }) async {
    GoRouter.of(context).go(path.path, extra: extra);
  }

  static Future<void> pushPage(
    BuildContext context,
    RouteEnum path, {
    Object? extra,
    String? params,
  }) async {
    GoRouter.of(context).push(path.path, extra: extra);
  }

  static void dialog(
    BuildContext? context,
    Widget content, {
    bool isDismis = true,
    EdgeInsets modalPadding = const EdgeInsets.symmetric(horizontal: 20),
  }) {
    showDialog(
      context: context ?? navigatorKey.currentContext!,
      barrierDismissible: isDismis,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
          insetPadding: modalPadding,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: content,
          ),
        );
      },
    );
  }

  static modalSingleButton(
    BuildContext? context, {
    bool dismissible = true,
    EdgeInsets modalPadding = const EdgeInsets.symmetric(horizontal: 20),
    required String title,
    required String description,
    String buttonText = '확인',
    Color? buttonBgColor,
    VoidCallback? onTap,
  }) {
    return dialog(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(20),
          // ConfirmButton(
          // ),
        ],
      ),
      isDismis: dismissible,
      modalPadding: modalPadding,
    );
  }

  static void toast(
    BuildContext? context,
    String text, {
    double bottomPosition = 100,
    String svgIcon = '',
    double iconSize = 20,
    Duration duration = const Duration(seconds: 2),
  }) {
    final FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(context ?? navigatorKey.currentContext!);
    Widget toast = Container(
      width:
          MediaQuery.sizeOf(context ?? navigatorKey.currentContext!).width - 32,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context ?? navigatorKey.currentContext!)
            .colorScheme
            .primaryContainer,
      ),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              softWrap: true,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: duration,
      positionedToastBuilder: (context, child, gravity) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: bottomPosition,
              child: child,
            ),
          ],
        );
      },
    );
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
