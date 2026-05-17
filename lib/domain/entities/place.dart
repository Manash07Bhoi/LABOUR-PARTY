import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;

  const Place({
    required this.id,
    required this.name,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, isActive, createdAt];
}

class PlaceWithStats extends Equatable {
  final Place place;
  final int totalWorks;

  const PlaceWithStats({
    required this.place,
    required this.totalWorks,
  });

  @override
  List<Object?> get props => [place, totalWorks];
}
