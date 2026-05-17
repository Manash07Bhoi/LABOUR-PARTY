import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<Settings> call() async {
    return await repository.getSettings();
  }
}

class SaveSettingsUseCase {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  Future<void> call(Settings settings) async {
    return await repository.saveSettings(settings);
  }
}

class ClearAllDataUseCase {
  final SettingsRepository repository;

  ClearAllDataUseCase(this.repository);

  Future<void> call(List<String> boxNames) async {
    return await repository.clearAllData(boxNames);
  }
}
