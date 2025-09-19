import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:transit_seoul/providers/user_cubit/user_cubit.dart';
import 'package:transit_seoul/services/bus_service.dart';
import 'package:transit_seoul/services/user_service.dart';

class InitBlocProvider {
  static List<SingleChildWidget> blocProvider() {
    return [
      BlocProvider(create: (context) => UserCubit(UserService.instance)),
      BlocProvider(create: (context) => SettingsCubit()..initializeSettings()),
      BlocProvider(
        create: (context) => BusInfoCubit(BusService())..initializeMap(),
      ),
    ];
  }
}
