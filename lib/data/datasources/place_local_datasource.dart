import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../models/place_model.dart';

class PlaceLocalDatasource {
  final Box<PlaceModel> placeBox = Hive.box<PlaceModel>(HiveBoxNames.places);

  Future<void> addPlace(PlaceModel place) async {
    await placeBox.put(place.id, place);
  }

  Future<void> updatePlace(PlaceModel place) async {
    await placeBox.put(place.id, place);
  }

  Future<void> deletePlace(String id) async {
    final place = placeBox.get(id);
    if (place != null) {
      // Soft delete
      final deletedPlace = PlaceModel(
        id: place.id,
        name: place.name,
        isActive: false,
        createdAt: place.createdAt,
      );
      await placeBox.put(id, deletedPlace);
    }
  }

  Future<List<PlaceModel>> getAllPlaces() async {
    return placeBox.values.where((p) => p.isActive).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<PlaceModel?> getPlaceById(String id) async {
    return placeBox.get(id);
  }
}
