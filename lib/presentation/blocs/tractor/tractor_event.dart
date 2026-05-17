part of 'tractor_bloc.dart';

abstract class TractorEvent extends Equatable {
  const TractorEvent();

  @override
  List<Object?> get props => [];
}

class LoadTractorsEvent extends TractorEvent {}

class AddTractorEvent extends TractorEvent {
  final Tractor tractor;
  const AddTractorEvent(this.tractor);

  @override
  List<Object?> get props => [tractor];
}

class UpdateTractorEvent extends TractorEvent {
  final Tractor tractor;
  const UpdateTractorEvent(this.tractor);

  @override
  List<Object?> get props => [tractor];
}

class DeleteTractorEvent extends TractorEvent {
  final String id;
  const DeleteTractorEvent(this.id);

  @override
  List<Object?> get props => [id];
}
