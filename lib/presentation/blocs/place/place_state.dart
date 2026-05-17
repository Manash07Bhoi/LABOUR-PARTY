part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object?> get props => [];
}

class PlaceInitial extends PlaceState {}

class PlaceLoadingState extends PlaceState {}

class PlaceLoadedState extends PlaceState {
  final List<PlaceWithStats> places;

  const PlaceLoadedState({required this.places});

  @override
  List<Object?> get props => [places];
}

class PlaceEmptyState extends PlaceState {}

class PlaceErrorState extends PlaceState {
  final String message;
  const PlaceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class PlaceDeleteBlockedState extends PlaceState {
  final String message;
  const PlaceDeleteBlockedState(this.message);

  @override
  List<Object?> get props => [message];
}

class PlaceOperationSuccessState extends PlaceState {
  final String message;
  const PlaceOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
