import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../models/driver_model.dart';

class DriverLocalDatasource {
  final Box<DriverModel> driverBox = Hive.box<DriverModel>(HiveBoxNames.drivers);

  Future<void> addDriver(DriverModel driver) async {
    await driverBox.put(driver.id, driver);
  }

  Future<void> updateDriver(DriverModel driver) async {
    await driverBox.put(driver.id, driver);
  }

  Future<void> deleteDriver(String id) async {
    final driver = driverBox.get(id);
    if (driver != null) {
      // Soft delete
      final deletedDriver = DriverModel(
        id: driver.id,
        name: driver.name,
        phone: driver.phone,
        isActive: false,
        createdAt: driver.createdAt,
      );
      await driverBox.put(id, deletedDriver);
    }
  }

  Future<List<DriverModel>> getAllDrivers() async {
    return driverBox.values.where((d) => d.isActive).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<DriverModel?> getDriverById(String id) async {
    return driverBox.get(id);
  }
}
