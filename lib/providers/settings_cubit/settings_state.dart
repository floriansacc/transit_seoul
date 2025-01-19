part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, fail }

extension SettingsStatusX on SettingsStatus {
  bool get isInitial => this == SettingsStatus.initial;
  bool get isLoading => this == SettingsStatus.loading;
  bool get isSuccess => this == SettingsStatus.success;
  bool get isFailed => this == SettingsStatus.fail;
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.isDarkTheme = ThemeEnum.light,
    this.isMapControl = false,
  });

  final SettingsStatus status;
  final ThemeEnum isDarkTheme;
  final bool isMapControl;

  SettingsState copyWith({
    SettingsStatus? status,
    ThemeEnum? isDarkTheme,
    bool? isMapControl,
  }) {
    return SettingsState(
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isMapControl: isMapControl ?? this.isMapControl,
    );
  }

  @override
  List<Object?> get props => [status, isDarkTheme, isMapControl];
}
