import '../entities/labour.dart';
import '../repositories/labour_repository.dart';
import '../repositories/work_repository.dart';

class AddLabourUseCase {
  final LabourRepository repository;
  AddLabourUseCase(this.repository);

  Future<void> call(Labour labour) async {
    return await repository.addLabour(labour);
  }
}

class UpdateLabourUseCase {
  final LabourRepository repository;
  UpdateLabourUseCase(this.repository);

  Future<void> call(Labour labour) async {
    return await repository.updateLabour(labour);
  }
}

class DeleteLabourUseCase {
  final LabourRepository repository;
  DeleteLabourUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteLabour(id);
  }
}

class GetAllLaboursUseCase {
  final LabourRepository repository;
  GetAllLaboursUseCase(this.repository);

  Future<List<Labour>> call() async {
    return await repository.getAllLabours();
  }
}

class GetLaboursWithStatsUseCase {
  final LabourRepository labourRepository;
  final WorkRepository workRepository;

  GetLaboursWithStatsUseCase(this.labourRepository, this.workRepository);

  Future<List<LabourWithStats>> call() async {
    final labours = await labourRepository.getAllLabours();
    final works = await workRepository.getAllWorks();

    return labours.map((labour) {
      int joinedWorks = 0;
      double totalEarned = 0;

      for (var work in works) {
        if (work.labourIds.contains(labour.id)) {
          joinedWorks++;
          totalEarned += work.amountPerLabour;
        }
      }

      return LabourWithStats(
        labour: labour,
        joinedWorks: joinedWorks,
        totalEarned: totalEarned,
      );
    }).toList();
  }
}
