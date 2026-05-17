import '../../domain/entities/driver.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/driver_local_datasource.dart';
import '../models/driver_model.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverLocalDatasource datasource;

  DriverRepositoryImpl(this.datasource);

  @override
  Future<void> addDriver(Driver driver) async {
    await datasource.addDriver(DriverModel.fromEntity(driver));
  }

  @override
  Future<void> updateDriver(Driver driver) async {
    await datasource.updateDriver(DriverModel.fromEntity(driver));
  }

  @override
  Future<void> deleteDriver(String id) async {
    await datasource.deleteDriver(id);
  }

  @override
  Future<List<Driver>> getAllDrivers() async {
    final models = await datasource.getAllDrivers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Driver?> getDriverById(String id) async {
    final model = await datasource.getDriverById(id);
    return model?.toEntity();
  }
}
