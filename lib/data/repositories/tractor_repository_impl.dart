import '../../domain/entities/tractor.dart';
import '../../domain/repositories/tractor_repository.dart';
import '../datasources/tractor_local_datasource.dart';
import '../models/tractor_model.dart';

class TractorRepositoryImpl implements TractorRepository {
  final TractorLocalDatasource datasource;

  TractorRepositoryImpl(this.datasource);

  @override
  Future<void> addTractor(Tractor tractor) async {
    await datasource.addTractor(TractorModel.fromEntity(tractor));
  }

  @override
  Future<void> updateTractor(Tractor tractor) async {
    await datasource.updateTractor(TractorModel.fromEntity(tractor));
  }

  @override
  Future<void> deleteTractor(String id) async {
    await datasource.deleteTractor(id);
  }

  @override
  Future<List<Tractor>> getAllTractors() async {
    final models = await datasource.getAllTractors();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Tractor?> getTractorById(String id) async {
    final model = await datasource.getTractorById(id);
    return model?.toEntity();
  }
}
