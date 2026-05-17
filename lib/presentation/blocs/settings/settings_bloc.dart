import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/settings_usecases.dart';
import '../../../core/constants/hive_box_names.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  final ClearAllDataUseCase clearAllData;

  SettingsBloc({
    required this.getSettings,
    required this.saveSettings,
    required this.clearAllData,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ClearAllDataEvent>(_onClearAllData);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    final settings = await getSettings();
    emit(SettingsLoadedState(isDarkMode: settings.isDarkMode));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<SettingsState> emit) async {
    final settings = await getSettings();
    final updatedSettings = settings.copyWith(isDarkMode: event.isDarkMode);
    await saveSettings(updatedSettings);
    emit(SettingsLoadedState(isDarkMode: event.isDarkMode));
  }

  Future<void> _onClearAllData(ClearAllDataEvent event, Emitter<SettingsState> emit) async {
    final boxesToClear = [
      HiveBoxNames.works,
      HiveBoxNames.labours,
      HiveBoxNames.drivers,
      HiveBoxNames.tractors,
      HiveBoxNames.places,
    ];
    
    await clearAllData(boxesToClear);
    emit(SettingsDataClearedState());
    
    // Reload settings just to go back to the normal loaded state
    add(LoadSettingsEvent());
  }
}
