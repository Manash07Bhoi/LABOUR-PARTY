import '../entities/work.dart';
import '../repositories/work_repository.dart';

class AddWorkUseCase {
  final WorkRepository repository;
  AddWorkUseCase(this.repository);

  Future<void> call(Work work) async {
    // Recompute amountPerLabour
    final computedAmount = work.labourCount > 0 ? work.totalAmount / work.labourCount : 0.0;
    final finalWork = Work(
      id: work.id,
      workName: work.workName,
      date: work.date,
      placeId: work.placeId,
      placeName: work.placeName,
      labourIds: work.labourIds,
      labourCount: work.labourCount,
      totalAmount: work.totalAmount,
      amountPerLabour: computedAmount,
      driverId: work.driverId,
      driverName: work.driverName,
      tractorId: work.tractorId,
      tractorName: work.tractorName,
      sandTrips: work.sandTrips,
      createdAt: work.createdAt,
      updatedAt: work.updatedAt,
    );
    return await repository.addWork(finalWork);
  }
}

class UpdateWorkUseCase {
  final WorkRepository repository;
  UpdateWorkUseCase(this.repository);

  Future<void> call(Work work) async {
    // Recompute amountPerLabour
    final computedAmount = work.labourCount > 0 ? work.totalAmount / work.labourCount : 0.0;
    final finalWork = Work(
      id: work.id,
      workName: work.workName,
      date: work.date,
      placeId: work.placeId,
      placeName: work.placeName,
      labourIds: work.labourIds,
      labourCount: work.labourCount,
      totalAmount: work.totalAmount,
      amountPerLabour: computedAmount,
      driverId: work.driverId,
      driverName: work.driverName,
      tractorId: work.tractorId,
      tractorName: work.tractorName,
      sandTrips: work.sandTrips,
      createdAt: work.createdAt,
      updatedAt: work.updatedAt,
    );
    return await repository.updateWork(finalWork);
  }
}

class DeleteWorkUseCase {
  final WorkRepository repository;
  DeleteWorkUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteWork(id); // Hard delete in datasource!
  }
}

class GetAllWorksUseCase {
  final WorkRepository repository;
  GetAllWorksUseCase(this.repository);

  Future<List<Work>> call() async {
    return await repository.getAllWorks();
  }
}
