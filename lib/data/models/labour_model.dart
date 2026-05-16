import 'package:hive/hive.dart';
import '../../domain/entities/labour.dart';

part 'labour_model.g.dart';

@HiveType(typeId: 1)
class LabourModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? phone;

  @HiveField(3)
  final bool isActive;

  @HiveField(4)
  final DateTime createdAt;

  LabourModel({
    required this.id,
    required this.name,
    this.phone,
    this.isActive = true,
    required this.createdAt,
  });

  factory LabourModel.fromEntity(Labour labour) {
    return LabourModel(
      id: labour.id,
      name: labour.name,
      phone: labour.phone,
      isActive: labour.isActive,
      createdAt: labour.createdAt,
    );
  }

  Labour toEntity() {
    return Labour(
      id: id,
      name: name,
      phone: phone,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
