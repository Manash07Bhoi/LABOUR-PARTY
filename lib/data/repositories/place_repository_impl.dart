import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_local_datasource.dart';
import '../models/place_model.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceLocalDatasource datasource;

  PlaceRepositoryImpl(this.datasource);

  @override
  Future<void> addPlace(Place place) async {
    await datasource.addPlace(PlaceModel.fromEntity(place));
  }

  @override
  Future<void> updatePlace(Place place) async {
    await datasource.updatePlace(PlaceModel.fromEntity(place));
  }

  @override
  Future<void> deletePlace(String id) async {
    await datasource.deletePlace(id);
  }

  @override
  Future<List<Place>> getAllPlaces() async {
    final models = await datasource.getAllPlaces();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    final model = await datasource.getPlaceById(id);
    return model?.toEntity();
  }
}
