import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:transit_seoul/services/bus_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class InitBlocProvider {
  static List<SingleChildWidget> blocProvider() {
    return [
      BlocProvider(create: (context) => SettingsCubit()..initializeSettings()),
      BlocProvider(
        create: (context) => BusInfoCubit(BusService()),
      ),
    ];
  }
}
