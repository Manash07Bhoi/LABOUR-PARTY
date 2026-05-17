import 'package:hive/hive.dart';
import '../../domain/entities/work.dart';

part 'work_model.g.dart';

@HiveType(typeId: 0)
class WorkModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workName;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String placeId;

  @HiveField(4)
  final String placeName;

  @HiveField(5)
  final List<String> labourIds;

  @HiveField(6)
  final int labourCount;

  @HiveField(7)
  final double totalAmount;

  @HiveField(9)
  final String? driverId;

  @HiveField(10)
  final String? driverName;

  @HiveField(11)
  final String? tractorId;

  @HiveField(12)
  final String? tractorName;

  @HiveField(13)
  final int sandTrips;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  WorkModel({
    required this.id,
    required this.workName,
    required this.date,
    required this.placeId,
    required this.placeName,
    required this.labourIds,
    required this.labourCount,
    required this.totalAmount,
    this.driverId,
    this.driverName,
    this.tractorId,
    this.tractorName,
    this.sandTrips = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkModel.fromEntity(Work work) {
    return WorkModel(
      id: work.id,
      workName: work.workName,
      date: work.date,
      placeId: work.placeId,
      placeName: work.placeName,
      labourIds: work.labourIds,
      labourCount: work.labourCount,
      totalAmount: work.totalAmount,
      driverId: work.driverId,
      driverName: work.driverName,
      tractorId: work.tractorId,
      tractorName: work.tractorName,
      sandTrips: work.sandTrips,
      createdAt: work.createdAt,
      updatedAt: work.updatedAt,
    );
  }

  Work toEntity() {
    return Work(
      id: id,
      workName: workName,
      date: date,
      placeId: placeId,
      placeName: placeName,
      labourIds: labourIds,
      labourCount: labourCount,
      totalAmount: totalAmount,
      driverId: driverId,
      driverName: driverName,
      tractorId: tractorId,
      tractorName: tractorName,
      sandTrips: sandTrips,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
