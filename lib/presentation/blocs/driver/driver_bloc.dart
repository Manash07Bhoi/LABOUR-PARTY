import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/driver.dart';
import '../../../domain/usecases/driver_usecases.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final GetDriversWithStatsUseCase getDriversWithStats;
  final AddDriverUseCase addDriver;
  final UpdateDriverUseCase updateDriver;
  final DeleteDriverUseCase deleteDriver;

  DriverBloc({
    required this.getDriversWithStats,
    required this.addDriver,
    required this.updateDriver,
    required this.deleteDriver,
  }) : super(DriverInitial()) {
    on<LoadDriversEvent>(_onLoadDrivers);
    on<AddDriverEvent>(_onAddDriver);
    on<UpdateDriverEvent>(_onUpdateDriver);
    on<DeleteDriverEvent>(_onDeleteDriver);
  }

  Future<void> _onLoadDrivers(LoadDriversEvent event, Emitter<DriverState> emit) async {
    emit(DriverLoadingState());
    try {
      final drivers = await getDriversWithStats();
      if (drivers.isEmpty) {
        emit(DriverEmptyState());
      } else {
        emit(DriverLoadedState(drivers: drivers));
      }
    } catch (e) {
      emit(DriverErrorState(e.toString()));
    }
  }

  Future<void> _onAddDriver(AddDriverEvent event, Emitter<DriverState> emit) async {
    try {
      await addDriver(event.driver);
      emit(const DriverOperationSuccessState('Driver added successfully'));
      add(LoadDriversEvent());
    } catch (e) {
      emit(DriverErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateDriver(UpdateDriverEvent event, Emitter<DriverState> emit) async {
    try {
      await updateDriver(event.driver);
      emit(const DriverOperationSuccessState('Driver updated successfully'));
      add(LoadDriversEvent());
    } catch (e) {
      emit(DriverErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteDriver(DeleteDriverEvent event, Emitter<DriverState> emit) async {
    try {
      await deleteDriver(event.id);
      emit(const DriverOperationSuccessState('Driver deleted successfully'));
      add(LoadDriversEvent());
    } catch (e) {
      emit(DriverErrorState(e.toString()));
    }
  }
}
