part of 'driver_bloc.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();

  @override
  List<Object?> get props => [];
}

class LoadDriversEvent extends DriverEvent {}

class AddDriverEvent extends DriverEvent {
  final Driver driver;
  const AddDriverEvent(this.driver);

  @override
  List<Object?> get props => [driver];
}

class UpdateDriverEvent extends DriverEvent {
  final Driver driver;
  const UpdateDriverEvent(this.driver);

  @override
  List<Object?> get props => [driver];
}

class DeleteDriverEvent extends DriverEvent {
  final String id;
  const DeleteDriverEvent(this.id);

  @override
  List<Object?> get props => [id];
}
