import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tractor.dart';
import '../../../domain/usecases/tractor_usecases.dart';

part 'tractor_event.dart';
part 'tractor_state.dart';

class TractorBloc extends Bloc<TractorEvent, TractorState> {
  final GetTractorsWithStatsUseCase getTractorsWithStats;
  final AddTractorUseCase addTractor;
  final UpdateTractorUseCase updateTractor;
  final DeleteTractorUseCase deleteTractor;

  TractorBloc({
    required this.getTractorsWithStats,
    required this.addTractor,
    required this.updateTractor,
    required this.deleteTractor,
  }) : super(TractorInitial()) {
    on<LoadTractorsEvent>(_onLoadTractors);
    on<AddTractorEvent>(_onAddTractor);
    on<UpdateTractorEvent>(_onUpdateTractor);
    on<DeleteTractorEvent>(_onDeleteTractor);
  }

  Future<void> _onLoadTractors(LoadTractorsEvent event, Emitter<TractorState> emit) async {
    emit(TractorLoadingState());
    try {
      final tractors = await getTractorsWithStats();
      if (tractors.isEmpty) {
        emit(TractorEmptyState());
      } else {
        emit(TractorLoadedState(tractors: tractors));
      }
    } catch (e) {
      emit(TractorErrorState(e.toString()));
    }
  }

  Future<void> _onAddTractor(AddTractorEvent event, Emitter<TractorState> emit) async {
    try {
      await addTractor(event.tractor);
      emit(const TractorOperationSuccessState('Tractor added successfully'));
      add(LoadTractorsEvent());
    } catch (e) {
      emit(TractorErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateTractor(UpdateTractorEvent event, Emitter<TractorState> emit) async {
    try {
      await updateTractor(event.tractor);
      emit(const TractorOperationSuccessState('Tractor updated successfully'));
      add(LoadTractorsEvent());
    } catch (e) {
      emit(TractorErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteTractor(DeleteTractorEvent event, Emitter<TractorState> emit) async {
    try {
      await deleteTractor(event.id);
      emit(const TractorOperationSuccessState('Tractor deleted successfully'));
      add(LoadTractorsEvent());
    } catch (e) {
      emit(TractorErrorState(e.toString()));
    }
  }
}
