import 'package:hive/hive.dart';
import '../../domain/entities/driver.dart';

part 'driver_model.g.dart';

@HiveType(typeId: 2)
class DriverModel extends HiveObject {
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

  DriverModel({
    required this.id,
    required this.name,
    this.phone,
    this.isActive = true,
    required this.createdAt,
  });

  factory DriverModel.fromEntity(Driver driver) {
    return DriverModel(
      id: driver.id,
      name: driver.name,
      phone: driver.phone,
      isActive: driver.isActive,
      createdAt: driver.createdAt,
    );
  }

  Driver toEntity() {
    return Driver(
      id: id,
      name: name,
      phone: phone,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
