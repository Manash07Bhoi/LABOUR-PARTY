import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 5)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  bool animationsEnabled;

  @HiveField(2)
  String currencySymbol;

  @HiveField(3)
  String dateFormat;

  @HiveField(4)
  String? userName;

  SettingsModel({
    this.isDarkMode = true, // Default per PRD
    this.animationsEnabled = true,
    this.currencySymbol = '₹',
    this.dateFormat = 'dd/MM/yyyy',
    this.userName,
  });
}
