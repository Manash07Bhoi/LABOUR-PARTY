import 'package:equatable/equatable.dart';

class Work extends Equatable {
  final String id;
  final String workName;
  final DateTime date;
  final String placeId;
  final String placeName;
  final List<String> labourIds;
  final int labourCount;
  final double totalAmount;
  final String? driverId;
  final String? driverName;
  final String? tractorId;
  final String? tractorName;
  final int sandTrips;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Work({
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

  @override
  List<Object?> get props => [
        id,
        workName,
        date,
        placeId,
        placeName,
        labourIds,
        labourCount,
        totalAmount,
        driverId,
        driverName,
        tractorId,
        tractorName,
        sandTrips,
        createdAt,
        updatedAt,
      ];
}
