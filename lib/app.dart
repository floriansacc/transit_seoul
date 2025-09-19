import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/pages/settings/loading_screen.dart';
import 'package:transit_seoul/providers/user_cubit/user_cubit.dart';
import 'package:transit_seoul/router/route_enum.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    setApp();
  }

  Future<void> setApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCubit userCubit = context.read<UserCubit>();

      await userCubit.initUser();

      if (!mounted) return;

      PublicMethod.goPage(
        context,
        RouteEnum.home,
        extra: userCubit.state.status.isFailed ? {'isLogout': true} : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}
