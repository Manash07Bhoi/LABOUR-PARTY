import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportData extends Equatable {
  final double totalAmount;
  final int totalWorks;
  final int totalSandTrips;
  final List<FlSpot> amountChartData;
  final List<FlSpot> sandChartData;
  final DateTime startDate;
  final DateTime endDate;

  const ReportData({
    required this.totalAmount,
    required this.totalWorks,
    required this.totalSandTrips,
    required this.amountChartData,
    required this.sandChartData,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        totalAmount,
        totalWorks,
        totalSandTrips,
        amountChartData,
        sandChartData,
        startDate,
        endDate,
      ];
}
