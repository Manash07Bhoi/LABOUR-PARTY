import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/labour.dart';
import '../../../domain/usecases/labour_usecases.dart';

part 'labour_event.dart';
part 'labour_state.dart';

class LabourBloc extends Bloc<LabourEvent, LabourState> {
  final GetLaboursWithStatsUseCase getLaboursWithStats;
  final AddLabourUseCase addLabour;
  final UpdateLabourUseCase updateLabour;
  final DeleteLabourUseCase deleteLabour;

  LabourBloc({
    required this.getLaboursWithStats,
    required this.addLabour,
    required this.updateLabour,
    required this.deleteLabour,
  }) : super(LabourInitial()) {
    on<LoadLaboursEvent>(_onLoadLabours);
    on<AddLabourEvent>(_onAddLabour);
    on<UpdateLabourEvent>(_onUpdateLabour);
    on<DeleteLabourEvent>(_onDeleteLabour);
  }

  Future<void> _onLoadLabours(LoadLaboursEvent event, Emitter<LabourState> emit) async {
    emit(LabourLoadingState());
    try {
      final labours = await getLaboursWithStats();
      if (labours.isEmpty) {
        emit(LabourEmptyState());
      } else {
        emit(LabourLoadedState(labours: labours));
      }
    } catch (e) {
      emit(LabourErrorState(e.toString()));
    }
  }

  Future<void> _onAddLabour(AddLabourEvent event, Emitter<LabourState> emit) async {
    try {
      await addLabour(event.labour);
      emit(const LabourOperationSuccessState('Labour added successfully'));
      add(LoadLaboursEvent());
    } catch (e) {
      emit(LabourErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateLabour(UpdateLabourEvent event, Emitter<LabourState> emit) async {
    try {
      await updateLabour(event.labour);
      emit(const LabourOperationSuccessState('Labour updated successfully'));
      add(LoadLaboursEvent());
    } catch (e) {
      emit(LabourErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteLabour(DeleteLabourEvent event, Emitter<LabourState> emit) async {
    try {
      await deleteLabour(event.id);
      emit(const LabourOperationSuccessState('Labour deleted successfully'));
      add(LoadLaboursEvent());
    } catch (e) {
      emit(LabourErrorState(e.toString()));
    }
  }
}
