import 'package:bloc/bloc.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/enums/settings_enum.dart';
import 'package:transit_seoul/enums/theme_enum.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void initializeSettings() {
    emit(state.copyWith(status: SettingsStatus.loading));

    bool isMapControl = prefs.getBool(SettingsEnum.mapControl.value) ?? false;

    String isDarkTheme =
        prefs.getString(SettingsEnum.theme.value) ?? ThemeEnum.light.name;
    emit(
      state.copyWith(
        status: SettingsStatus.success,
        isDarkTheme: ThemeEnum.values.firstWhere((e) => e.name == isDarkTheme),
        isMapControl: isMapControl,
      ),
    );
  }

  void switchTheme(ThemeEnum theme) {
    prefs.setString(SettingsEnum.theme.value, theme.name);
    emit(state.copyWith(status: SettingsStatus.success, isDarkTheme: theme));
    print(state.isDarkTheme);
  }

  void switchMapControl({required bool entry}) {
    emit(state.copyWith(status: SettingsStatus.loading));

    prefs.setBool(SettingsEnum.mapControl.value, entry);
    emit(state.copyWith(status: SettingsStatus.success, isMapControl: entry));
  }
}
