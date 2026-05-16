import 'package:equatable/equatable.dart';

class Tractor extends Equatable {
  final String id;
  final String name;
  final String? plateNumber;
  final bool isActive;
  final DateTime createdAt;

  const Tractor({
    required this.id,
    required this.name,
    this.plateNumber,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, plateNumber, isActive, createdAt];
}

class TractorWithStats extends Equatable {
  final Tractor tractor;
  final int totalWorks;
  final int totalSandTrips;

  const TractorWithStats({
    required this.tractor,
    required this.totalWorks,
    required this.totalSandTrips,
  });

  @override
  List<Object?> get props => [tractor, totalWorks, totalSandTrips];
}
