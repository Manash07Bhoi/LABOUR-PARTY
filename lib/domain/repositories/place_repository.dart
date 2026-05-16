import '../entities/place.dart';

abstract class PlaceRepository {
  Future<void> addPlace(Place place);
  Future<void> updatePlace(Place place);
  Future<void> deletePlace(String id); // soft delete
  Future<List<Place>> getAllPlaces();
  Future<Place?> getPlaceById(String id);
}
