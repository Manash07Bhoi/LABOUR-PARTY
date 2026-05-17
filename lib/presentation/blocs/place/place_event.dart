part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlacesEvent extends PlaceEvent {}

class AddPlaceEvent extends PlaceEvent {
  final Place place;
  const AddPlaceEvent(this.place);

  @override
  List<Object?> get props => [place];
}

class UpdatePlaceEvent extends PlaceEvent {
  final Place place;
  const UpdatePlaceEvent(this.place);

  @override
  List<Object?> get props => [place];
}

class DeletePlaceEvent extends PlaceEvent {
  final String id;
  const DeletePlaceEvent(this.id);

  @override
  List<Object?> get props => [id];
}
