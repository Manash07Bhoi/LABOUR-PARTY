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
      settings = SettingsModel();
      await box.put('app_settings', settings);
    }

    return Settings(isDarkMode: settings.isDarkMode, language: settings.languageCode);
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final box = Hive.box<SettingsModel>(HiveBoxNames.settings);
    SettingsModel? model = box.get('app_settings');
    if (model != null) {
      model.isDarkMode = settings.isDarkMode;
      model.languageCode = settings.language;
      await model.save();
    } else {
      await box.put('app_settings', SettingsModel(isDarkMode: settings.isDarkMode, languageCode: settings.language));
    }
  }

  @override
  Future<void> clearAllData(List<String> boxNames) async {
    await HiveHelpers.clearAllData(boxNames);
  }
}
