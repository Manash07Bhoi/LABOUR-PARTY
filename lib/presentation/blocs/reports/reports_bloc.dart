import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/report_data.dart';
import '../../../domain/usecases/report_usecases.dart';
import '../../../domain/repositories/work_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetReportDataUseCase getReportData;
  final WorkRepository workRepository;

  ReportsBloc({
    required this.getReportData,
    required this.workRepository,
  }) : super(ReportsInitial()) {
    on<LoadWeeklyReportEvent>(_onLoadWeeklyReport);
    on<LoadMonthlyReportEvent>(_onLoadMonthlyReport);
  }

  Future<void> _onLoadWeeklyReport(LoadWeeklyReportEvent event, Emitter<ReportsState> emit) async {
    emit(ReportsLoadingState());
    try {
      final start = event.endDate.subtract(const Duration(days: 6));
      final end = event.endDate;
      
      final startOfDay = DateTime(start.year, start.month, start.day);
      final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

      final works = await workRepository.getWorksByDateRange(startOfDay, endOfDay);

      if (works.isEmpty) {
        emit(ReportsEmptyState());
        return;
      }

      double totalAmount = 0;
      int totalWorks = works.length;
      int totalSandTrips = 0;

      Map<String, double> chartMap = {};
      
      // Initialize all 7 days with 0.0
      for (int i = 0; i < 7; i++) {
        final currentDay = startOfDay.add(Duration(days: i));
        final dayLabel = DateFormat('E').format(currentDay); // Mon, Tue, etc.
        chartMap[dayLabel] = 0.0;
      }

      for (var work in works) {
        totalAmount += work.totalAmount;
        totalSandTrips += work.sandTrips;

        final dayLabel = DateFormat('E').format(work.date);
        chartMap[dayLabel] = (chartMap[dayLabel] ?? 0) + work.totalAmount;
      }

      // We still use GetReportDataUseCase to format things if needed, but per the PRD instructions,
      // it's easier to build it directly here or modify the usecase. I'll build the ReportData here.
      
      List<FlSpot> amountChartData = [];
      int index = 0;
      for (var entry in chartMap.entries) {
        amountChartData.add(FlSpot(index.toDouble(), entry.value));
        index++;
      }

      final reportData = ReportData(
        totalAmount: totalAmount,
        totalWorks: totalWorks,
        totalSandTrips: totalSandTrips,
        amountChartData: amountChartData,
        sandChartData: const [], // Simplification for now, UI only shows one chart based on amount usually
        startDate: startOfDay,
        endDate: endOfDay,
      );

      emit(ReportsLoadedState(reportData: reportData, chartMap: chartMap));
    } catch (e) {
      emit(ReportsErrorState(e.toString()));
    }
  }

  Future<void> _onLoadMonthlyReport(LoadMonthlyReportEvent event, Emitter<ReportsState> emit) async {
    emit(ReportsLoadingState());
    try {
      final startOfDay = DateTime(event.year, event.month, 1);
      final daysInMonth = DateTime(event.year, event.month + 1, 0).day;
      final endOfDay = DateTime(event.year, event.month, daysInMonth, 23, 59, 59);

      final works = await workRepository.getWorksByDateRange(startOfDay, endOfDay);

      if (works.isEmpty) {
        emit(ReportsEmptyState());
        return;
      }

      double totalAmount = 0;
      int totalWorks = works.length;
      int totalSandTrips = 0;

      Map<String, double> chartMap = {};
      
      // Initialize all days in month with 0.0
      for (int i = 1; i <= daysInMonth; i++) {
        chartMap[i.toString()] = 0.0;
      }

      for (var work in works) {
        totalAmount += work.totalAmount;
        totalSandTrips += work.sandTrips;

        final dayStr = work.date.day.toString();
        chartMap[dayStr] = (chartMap[dayStr] ?? 0) + work.totalAmount;
      }
      
      List<FlSpot> amountChartData = [];
      int index = 0;
      for (var entry in chartMap.entries) {
        amountChartData.add(FlSpot(index.toDouble(), entry.value));
        index++;
      }

      final reportData = ReportData(
        totalAmount: totalAmount,
        totalWorks: totalWorks,
        totalSandTrips: totalSandTrips,
        amountChartData: amountChartData,
        sandChartData: const [],
        startDate: startOfDay,
        endDate: endOfDay,
      );

      emit(ReportsLoadedState(reportData: reportData, chartMap: chartMap));
    } catch (e) {
      emit(ReportsErrorState(e.toString()));
    }
  }
}
