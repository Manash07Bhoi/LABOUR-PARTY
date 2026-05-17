part of 'driver_bloc.dart';

abstract class DriverState extends Equatable {
  const DriverState();

  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoadingState extends DriverState {}

class DriverLoadedState extends DriverState {
  final List<DriverWithStats> drivers;

  const DriverLoadedState({required this.drivers});

  @override
  List<Object?> get props => [drivers];
}

class DriverEmptyState extends DriverState {}

class DriverErrorState extends DriverState {
  final String message;
  const DriverErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class DriverOperationSuccessState extends DriverState {
  final String message;
  const DriverOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
