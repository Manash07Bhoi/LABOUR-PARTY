part of 'reports_bloc.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoadingState extends ReportsState {}

class ReportsLoadedState extends ReportsState {
  final ReportData reportData;
  final Map<String, double> chartMap;

  const ReportsLoadedState({
    required this.reportData,
    required this.chartMap,
  });

  @override
  List<Object?> get props => [reportData, chartMap];
}

class ReportsEmptyState extends ReportsState {}

class ReportsErrorState extends ReportsState {
  final String message;
  const ReportsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
