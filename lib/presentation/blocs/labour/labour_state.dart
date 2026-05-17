part of 'labour_bloc.dart';

abstract class LabourState extends Equatable {
  const LabourState();

  @override
  List<Object?> get props => [];
}

class LabourInitial extends LabourState {}

class LabourLoadingState extends LabourState {}

class LabourLoadedState extends LabourState {
  final List<LabourWithStats> labours;

  const LabourLoadedState({required this.labours});

  @override
  List<Object?> get props => [labours];
}

class LabourEmptyState extends LabourState {}

class LabourErrorState extends LabourState {
  final String message;
  const LabourErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LabourOperationSuccessState extends LabourState {
  final String message;
  const LabourOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
