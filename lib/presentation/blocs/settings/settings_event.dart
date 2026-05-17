part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {
  final bool isDarkMode;
  const ToggleThemeEvent(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class ClearAllDataEvent extends SettingsEvent {}
