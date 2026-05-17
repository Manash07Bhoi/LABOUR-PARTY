import 'package:hive/hive.dart';
import '../../domain/entities/tractor.dart';

part 'tractor_model.g.dart';

@HiveType(typeId: 3)
class TractorModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? plateNumber;

  @HiveField(3)
  final bool isActive;

  @HiveField(4)
  final DateTime createdAt;

  TractorModel({
    required this.id,
    required this.name,
    this.plateNumber,
    this.isActive = true,
    required this.createdAt,
  });

  factory TractorModel.fromEntity(Tractor tractor) {
    return TractorModel(
      id: tractor.id,
      name: tractor.name,
      plateNumber: tractor.plateNumber,
      isActive: tractor.isActive,
      createdAt: tractor.createdAt,
    );
  }

  Tractor toEntity() {
    return Tractor(
      id: id,
      name: name,
      plateNumber: plateNumber,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
