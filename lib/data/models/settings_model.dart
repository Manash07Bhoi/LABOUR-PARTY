import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 5)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String currencySymbol;

  @HiveField(2)
  String languageCode;

  SettingsModel({
    this.isDarkMode = true, // Default per PRD
    this.currencySymbol = '₹',
    this.languageCode = 'en',
  });
}
