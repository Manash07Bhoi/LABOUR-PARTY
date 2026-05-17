import 'package:hive/hive.dart';

class HiveHelpers {
  HiveHelpers._();

  static Future<void> safelyCloseBoxes(List<String> boxNames) async {
    for (final name in boxNames) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).close();
      }
    }
  }

  static Future<void> clearAllData(List<String> boxNames) async {
    for (final name in boxNames) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).clear();
      }
    }
  }
}
