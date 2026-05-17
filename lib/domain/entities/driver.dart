import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final bool isActive;
  final DateTime createdAt;

  const Driver({
    required this.id,
    required this.name,
    this.phone,
    this.isActive = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, isActive, createdAt];
}

class DriverWithStats extends Equatable {
  final Driver driver;
  final int totalWorks;

  const DriverWithStats({
    required this.driver,
    required this.totalWorks,
  });

  @override
  List<Object?> get props => [driver, totalWorks];
}
