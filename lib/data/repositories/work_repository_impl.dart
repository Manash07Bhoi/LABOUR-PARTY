import '../../domain/entities/work.dart';
import '../../domain/repositories/work_repository.dart';
import '../datasources/work_local_datasource.dart';
import '../models/work_model.dart';

class WorkRepositoryImpl implements WorkRepository {
  final WorkLocalDatasource datasource;

  WorkRepositoryImpl(this.datasource);

  @override
  Future<void> addWork(Work work) async {
    await datasource.addWork(WorkModel.fromEntity(work));
  }

  @override
  Future<void> updateWork(Work work) async {
    await datasource.updateWork(WorkModel.fromEntity(work));
  }

  @override
  Future<void> deleteWork(String id) async {
    await datasource.deleteWork(id);
  }

  @override
  Future<List<Work>> getAllWorks() async {
    final models = await datasource.getAllWorks();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Work?> getWorkById(String id) async {
    final model = await datasource.getWorkById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Work>> getWorksByDateRange(DateTime start, DateTime end) async {
    final models = await datasource.getWorksByDateRange(start, end);
    return models.map((m) => m.toEntity()).toList();
  }
}
