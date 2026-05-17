import '../entities/driver.dart';
import '../repositories/driver_repository.dart';
import '../repositories/work_repository.dart';

class AddDriverUseCase {
  final DriverRepository repository;
  AddDriverUseCase(this.repository);

  Future<void> call(Driver driver) async {
    return await repository.addDriver(driver);
  }
}

class UpdateDriverUseCase {
  final DriverRepository repository;
  UpdateDriverUseCase(this.repository);

  Future<void> call(Driver driver) async {
    return await repository.updateDriver(driver);
  }
}

class DeleteDriverUseCase {
  final DriverRepository repository;
  DeleteDriverUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteDriver(id);
  }
}

class GetAllDriversUseCase {
  final DriverRepository repository;
  GetAllDriversUseCase(this.repository);

  Future<List<Driver>> call() async {
    return await repository.getAllDrivers();
  }
}

class GetDriversWithStatsUseCase {
  final DriverRepository driverRepository;
  final WorkRepository workRepository;

  GetDriversWithStatsUseCase(this.driverRepository, this.workRepository);

  Future<List<DriverWithStats>> call() async {
    final drivers = await driverRepository.getAllDrivers();
    final works = await workRepository.getAllWorks();

    return drivers.map((driver) {
      int totalWorks = 0;

      for (var work in works) {
        if (work.driverId == driver.id) {
          totalWorks++;
        }
      }

      return DriverWithStats(
        driver: driver,
        totalWorks: totalWorks,
      );
    }).toList();
  }
}
