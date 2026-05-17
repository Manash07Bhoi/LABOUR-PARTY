part of 'work_bloc.dart';

abstract class WorkState extends Equatable {
  const WorkState();

  @override
  List<Object?> get props => [];
}

class WorkInitial extends WorkState {}

class WorkLoadingState extends WorkState {}

class DashboardLoadedState extends WorkState {
  final List<Work> recentWorks;
  final int todayWorksCount;
  final double totalSpent;
  final int totalSandTrips;
  final int activeDrivers;
  final int todayLaboursCount;

  const DashboardLoadedState({
    required this.recentWorks,
    required this.todayWorksCount,
    required this.totalSpent,
    required this.totalSandTrips,
    required this.activeDrivers,
    required this.todayLaboursCount,
  });

  @override
  List<Object?> get props => [
    recentWorks,
    todayWorksCount,
    totalSpent,
    totalSandTrips,
    activeDrivers,
    todayLaboursCount
  ];
}

class WorkListLoadedState extends WorkState {
  final List<Work> works;

  const WorkListLoadedState({required this.works});

  @override
  List<Object?> get props => [works];
}

class WorkEmptyState extends WorkState {}

class WorkErrorState extends WorkState {
  final String message;
  const WorkErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkOperationSuccessState extends WorkState {
  final String message;
  const WorkOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
