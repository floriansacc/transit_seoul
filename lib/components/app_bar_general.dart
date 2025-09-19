import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit_seoul/components/rounded_picture.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/providers/user_cubit/user_cubit.dart';
import 'package:transit_seoul/router/route_enum.dart';
import 'package:transit_seoul/styles/style_text.dart';

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
      centerTitle: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      forceMaterialTransparency: true,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => PublicMethod.pushPage(context, RouteEnum.my),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state.userData?.picture != null) {
                  return RoundedPicture(
                    heroTag: 'my-picture-hero',
                    imageUrl: state.userData!.picture!,
                    size: 24,
                  );
                }
                return Icon(Icons.account_circle);
              },
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => PublicMethod.pushPage(context, RouteEnum.settings),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.settings),
          ),
        ),
      ],
      title: Text(
        'Transit Seoul',
        style: StyleText.headlineSmall(context),
      ),
    );
  }
}
