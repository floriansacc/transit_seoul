import 'package:bloc/bloc.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/enums/theme_enum.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void initializeTheme() {
    emit(state.copyWith(status: SettingsStatus.loading));

    String? isDarkTheme =
        prefs.getString('activeTheme') ?? ThemeEnum.light.name;
    emit(
      state.copyWith(
        status: SettingsStatus.success,
        isDarkTheme: ThemeEnum.values.firstWhere((e) => e.name == isDarkTheme),
      ),
    );
  }

  void switchTheme(ThemeEnum theme) {
    prefs.setString('activeTheme', theme.name);
    emit(state.copyWith(status: SettingsStatus.success, isDarkTheme: theme));
  }
}
