import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_box_names.dart';
import '../../../data/models/settings_model.dart';
import '../../../core/utils/hive_helpers.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ClearAllDataEvent>(_onClearAllData);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    final box = Hive.box<SettingsModel>(HiveBoxNames.settings);
    SettingsModel? settings = box.get('app_settings');
    
    if (settings == null) {
      settings = SettingsModel();
      await box.put('app_settings', settings);
    }
    
    emit(SettingsLoadedState(isDarkMode: settings.isDarkMode));
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<SettingsState> emit) async {
    final box = Hive.box<SettingsModel>(HiveBoxNames.settings);
    SettingsModel? settings = box.get('app_settings');
    
    if (settings != null) {
      settings.isDarkMode = event.isDarkMode;
      await settings.save();
      emit(SettingsLoadedState(isDarkMode: settings.isDarkMode));
    }
  }

  Future<void> _onClearAllData(ClearAllDataEvent event, Emitter<SettingsState> emit) async {
    final boxesToClear = [
      HiveBoxNames.works,
      HiveBoxNames.labours,
      HiveBoxNames.drivers,
      HiveBoxNames.tractors,
      HiveBoxNames.places,
    ];
    
    await HiveHelpers.clearAllData(boxesToClear);
    emit(SettingsDataClearedState());
    
    // Reload settings just to go back to the normal loaded state
    add(LoadSettingsEvent());
  }
}
