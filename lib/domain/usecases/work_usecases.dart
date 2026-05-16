import '../entities/work.dart';
import '../repositories/work_repository.dart';

class AddWorkUseCase {
  final WorkRepository repository;
  AddWorkUseCase(this.repository);

  Future<void> call(Work work) async {
    return await repository.addWork(work);
  }
}

class UpdateWorkUseCase {
  final WorkRepository repository;
  UpdateWorkUseCase(this.repository);

  Future<void> call(Work work) async {
    return await repository.updateWork(work);
  }
}

class DeleteWorkUseCase {
  final WorkRepository repository;
  DeleteWorkUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteWork(id);
  }
}

class GetAllWorksUseCase {
  final WorkRepository repository;
  GetAllWorksUseCase(this.repository);

  Future<List<Work>> call() async {
    return await repository.getAllWorks();
  }
}
