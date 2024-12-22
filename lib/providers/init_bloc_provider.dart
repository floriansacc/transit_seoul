import 'package:bus_app/providers/settings_cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class InitBlocProvider {
  static List<SingleChildWidget> blocProvider() {
    return [
      BlocProvider(create: (context) => SettingsCubit()..initializeTheme()),
    ];
  }
}
