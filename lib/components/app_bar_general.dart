import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:flutter/material.dart';

class AppBarGeneral extends StatefulWidget implements PreferredSizeWidget {
  const AppBarGeneral({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarGeneral> createState() => _AppBarGeneralState();
}

class _AppBarGeneralState extends State<AppBarGeneral> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      forceMaterialTransparency: true,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => PublicMethod.pushPage(context, RouteEnum.settings),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.settings),
          ),
        ),
      ],
      title: Text(
        'Transit Seoul',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
