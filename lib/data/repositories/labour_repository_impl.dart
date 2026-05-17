import '../../domain/entities/labour.dart';
import '../../domain/repositories/labour_repository.dart';
import '../datasources/labour_local_datasource.dart';
import '../models/labour_model.dart';

class LabourRepositoryImpl implements LabourRepository {
  final LabourLocalDatasource datasource;

  LabourRepositoryImpl(this.datasource);

  @override
  Future<void> addLabour(Labour labour) async {
    await datasource.addLabour(LabourModel.fromEntity(labour));
  }

  @override
  Future<void> updateLabour(Labour labour) async {
    await datasource.updateLabour(LabourModel.fromEntity(labour));
  }

  @override
  Future<void> deleteLabour(String id) async {
    await datasource.deleteLabour(id);
  }

  @override
  Future<List<Labour>> getAllLabours() async {
    final models = await datasource.getAllLabours();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Labour?> getLabourById(String id) async {
    final model = await datasource.getLabourById(id);
    return model?.toEntity();
  }
}
