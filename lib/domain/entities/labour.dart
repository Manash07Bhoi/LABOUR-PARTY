import 'package:equatable/equatable.dart';

class Labour extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final bool isActive;
  final DateTime createdAt;

  const Labour({
    required this.id,
    required this.name,
    this.phone,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, isActive, createdAt];
}

class LabourWithStats extends Equatable {
  final Labour labour;
  final int joinedWorks;
  final double totalEarned;

  const LabourWithStats({
    required this.labour,
    required this.joinedWorks,
    required this.totalEarned,
  });

  @override
  List<Object?> get props => [labour, joinedWorks, totalEarned];
}
