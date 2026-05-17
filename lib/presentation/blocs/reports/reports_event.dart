part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeeklyReportEvent extends ReportsEvent {
  final DateTime endDate; // Often today
  const LoadWeeklyReportEvent({required this.endDate});

  @override
  List<Object?> get props => [endDate];
}

class LoadMonthlyReportEvent extends ReportsEvent {
  final int year;
  final int month;
  const LoadMonthlyReportEvent({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}
