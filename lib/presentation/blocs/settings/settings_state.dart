part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final bool isDarkMode;

  const SettingsLoadedState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class SettingsDataClearedState extends SettingsState {}
