import '../entities/driver.dart';

abstract class DriverRepository {
  Future<void> addDriver(Driver driver);
  Future<void> updateDriver(Driver driver);
  Future<void> deleteDriver(String id); // soft delete
  Future<List<Driver>> getAllDrivers();
  Future<Driver?> getDriverById(String id);
}
