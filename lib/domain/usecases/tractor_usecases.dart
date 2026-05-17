import '../entities/tractor.dart';
import '../repositories/tractor_repository.dart';
import '../repositories/work_repository.dart';

class AddTractorUseCase {
  final TractorRepository repository;
  AddTractorUseCase(this.repository);

  Future<void> call(Tractor tractor) async {
    return await repository.addTractor(tractor);
  }
}

class UpdateTractorUseCase {
  final TractorRepository repository;
  UpdateTractorUseCase(this.repository);

  Future<void> call(Tractor tractor) async {
    return await repository.updateTractor(tractor);
  }
}

class DeleteTractorUseCase {
  final TractorRepository repository;
  DeleteTractorUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTractor(id);
  }
}

class GetAllTractorsUseCase {
  final TractorRepository repository;
  GetAllTractorsUseCase(this.repository);

  Future<List<Tractor>> call() async {
    return await repository.getAllTractors();
  }
}

class GetTractorsWithStatsUseCase {
  final TractorRepository tractorRepository;
  final WorkRepository workRepository;

  GetTractorsWithStatsUseCase(this.tractorRepository, this.workRepository);

  Future<List<TractorWithStats>> call() async {
    final tractors = await tractorRepository.getAllTractors();
    final works = await workRepository.getAllWorks();

    return tractors.map((tractor) {
      int totalWorks = 0;
      int totalSandTrips = 0;

      for (var work in works) {
        if (work.tractorId == tractor.id) {
          totalWorks++;
          totalSandTrips += work.sandTrips;
        }
      }

      return TractorWithStats(
        tractor: tractor,
        totalWorks: totalWorks,
        totalSandTrips: totalSandTrips,
      );
    }).toList();
  }
}
