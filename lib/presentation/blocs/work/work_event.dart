part of 'work_bloc.dart';

abstract class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardDataEvent extends WorkEvent {}

class LoadAllWorksEvent extends WorkEvent {}

class SearchWorksEvent extends WorkEvent {
  final String query;
  const SearchWorksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddWorkEvent extends WorkEvent {
  final Work work;
  const AddWorkEvent(this.work);

  @override
  List<Object?> get props => [work];
}

class UpdateWorkEvent extends WorkEvent {
  final Work work;
  const UpdateWorkEvent(this.work);

  @override
  List<Object?> get props => [work];
}

class DeleteWorkEvent extends WorkEvent {
  final String id;
  const DeleteWorkEvent(this.id);

  @override
  List<Object?> get props => [id];
}
