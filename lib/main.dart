import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/enums/theme_enum.dart';
import 'package:transit_seoul/firebase_options.dart';
import 'package:transit_seoul/providers/init_bloc_provider.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'router/router.dart';
import 'styles/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PublicMethod.preferenceController();
  AuthRepository.initialize(
    appKey: dotenv.env['KAKAO_JAVASCRIPT_KEY']!,
    baseUrl: dotenv.env['BASE_URL']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: InitBlocProvider.blocProvider(),
      child: const AppThemeWrapper(),
    );
  }
}

class AppThemeWrapper extends StatelessWidget {
  const AppThemeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeEnum activeTheme = context.watch<SettingsCubit>().state.isDarkTheme;

    final Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme =
        AppTheme.createTextTheme(context, 'Roboto', 'Nanum Gothic');

    AppTheme appTheme = AppTheme(textTheme);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Transit Seoul',
      debugShowCheckedModeBanner: false,
      theme: switch (activeTheme) {
        ThemeEnum.dark => appTheme.dark(),
        ThemeEnum.light => appTheme.light(),
        ThemeEnum.system =>
          brightness == Brightness.dark ? appTheme.dark() : appTheme.light(),
      },
    );
  }
}
