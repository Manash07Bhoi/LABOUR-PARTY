part of 'labour_bloc.dart';

abstract class LabourEvent extends Equatable {
  const LabourEvent();

  @override
  List<Object?> get props => [];
}

class LoadLaboursEvent extends LabourEvent {}

class AddLabourEvent extends LabourEvent {
  final Labour labour;
  const AddLabourEvent(this.labour);

  @override
  List<Object?> get props => [labour];
}

class UpdateLabourEvent extends LabourEvent {
  final Labour labour;
  const UpdateLabourEvent(this.labour);

  @override
  List<Object?> get props => [labour];
}

class DeleteLabourEvent extends LabourEvent {
  final String id;
  const DeleteLabourEvent(this.id);

  @override
  List<Object?> get props => [id];
}
