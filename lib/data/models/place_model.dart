import 'package:hive/hive.dart';
import '../../domain/entities/place.dart';

part 'place_model.g.dart';

@HiveType(typeId: 4)
class PlaceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isActive;

  @HiveField(3)
  final DateTime createdAt;

  PlaceModel({
    required this.id,
    required this.name,
    this.isActive = true,
    required this.createdAt,
  });

  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      id: place.id,
      name: place.name,
      isActive: place.isActive,
      createdAt: place.createdAt,
    );
  }

  Place toEntity() {
    return Place(
      id: id,
      name: name,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
