import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/settings_model.dart';
import '../../core/constants/hive_box_names.dart';
import '../../core/utils/hive_helpers.dart';
import 'package:hive/hive.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Settings> getSettings() async {
    final box = Hive.box<SettingsModel>(HiveBoxNames.settings);
    SettingsModel? settings = box.get('app_settings');

    if (settings == null) {
      settings = SettingsModel(
        isDarkMode: true,
        animationsEnabled: true,
        currencySymbol: '₹',
        dateFormat: 'dd/MM/yyyy',
      );
      await box.put('settings', settings);
    }

    return Settings(
      isDarkMode: settings.isDarkMode,
      animationsEnabled: settings.animationsEnabled,
      currencySymbol: settings.currencySymbol,
      dateFormat: settings.dateFormat,
      userName: settings.userName,
    );
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final box = Hive.box<SettingsModel>(HiveBoxNames.settings);
    SettingsModel? model = box.get('settings');
    if (model != null) {
      model.isDarkMode = settings.isDarkMode;
      model.animationsEnabled = settings.animationsEnabled;
      model.currencySymbol = settings.currencySymbol;
      model.dateFormat = settings.dateFormat;
      model.userName = settings.userName;
      await model.save();
    } else {
      await box.put('settings', SettingsModel(
        isDarkMode: settings.isDarkMode,
        animationsEnabled: settings.animationsEnabled,
        currencySymbol: settings.currencySymbol,
        dateFormat: settings.dateFormat,
        userName: settings.userName,
      ));
    }
  }

  @override
  Future<void> clearAllData(List<String> boxNames) async {
    await HiveHelpers.clearAllData(boxNames);
  }
}
