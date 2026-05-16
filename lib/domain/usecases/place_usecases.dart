import '../entities/place.dart';
import '../repositories/place_repository.dart';
import '../repositories/work_repository.dart';

class AddPlaceUseCase {
  final PlaceRepository repository;
  AddPlaceUseCase(this.repository);

  Future<void> call(Place place) async {
    return await repository.addPlace(place);
  }
}

class UpdatePlaceUseCase {
  final PlaceRepository repository;
  UpdatePlaceUseCase(this.repository);

  Future<void> call(Place place) async {
    return await repository.updatePlace(place);
  }
}

class DeletePlaceUseCase {
  final PlaceRepository repository;
  DeletePlaceUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deletePlace(id);
  }
}

class GetAllPlacesUseCase {
  final PlaceRepository repository;
  GetAllPlacesUseCase(this.repository);

  Future<List<Place>> call() async {
    return await repository.getAllPlaces();
  }
}

class GetPlacesWithStatsUseCase {
  final PlaceRepository placeRepository;
  final WorkRepository workRepository;

  GetPlacesWithStatsUseCase(this.placeRepository, this.workRepository);

  Future<List<PlaceWithStats>> call() async {
    final places = await placeRepository.getAllPlaces();
    final works = await workRepository.getAllWorks();

    return places.map((place) {
      int totalWorks = 0;

      for (var work in works) {
        if (work.placeId == place.id) {
          totalWorks++;
        }
      }

      return PlaceWithStats(
        place: place,
        totalWorks: totalWorks,
      );
    }).toList();
  }
}
