part of 'tractor_bloc.dart';

abstract class TractorState extends Equatable {
  const TractorState();

  @override
  List<Object?> get props => [];
}

class TractorInitial extends TractorState {}

class TractorLoadingState extends TractorState {}

class TractorLoadedState extends TractorState {
  final List<TractorWithStats> tractors;

  const TractorLoadedState({required this.tractors});

  @override
  List<Object?> get props => [tractors];
}

class TractorEmptyState extends TractorState {}

class TractorErrorState extends TractorState {
  final String message;
  const TractorErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TractorOperationSuccessState extends TractorState {
  final String message;
  const TractorOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
