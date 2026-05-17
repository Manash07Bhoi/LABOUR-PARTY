import 'package:fl_chart/fl_chart.dart';
import '../entities/report_data.dart';
import '../repositories/work_repository.dart';

class GetReportDataUseCase {
  final WorkRepository workRepository;
  GetReportDataUseCase(this.workRepository);

  Future<ReportData> call(DateTime start, DateTime end) async {
    final works = await workRepository.getWorksByDateRange(start, end);

    double totalAmount = 0;
    int totalWorks = works.length;
    int totalSandTrips = 0;

    // We'll group by day for the chart
    Map<int, double> amountsPerDay = {};
    Map<int, int> sandTripsPerDay = {};

    for (var work in works) {
      totalAmount += work.totalAmount;
      totalSandTrips += work.sandTrips;

      final dayIndex = work.date.difference(start).inDays;
      if (dayIndex >= 0) {
        amountsPerDay[dayIndex] = (amountsPerDay[dayIndex] ?? 0) + work.totalAmount;
        sandTripsPerDay[dayIndex] = (sandTripsPerDay[dayIndex] ?? 0) + work.sandTrips;
      }
    }

    final int daysInRange = end.difference(start).inDays + 1;
    List<FlSpot> amountChartData = [];
    List<FlSpot> sandChartData = [];

    for (int i = 0; i < daysInRange; i++) {
      amountChartData.add(FlSpot(i.toDouble(), amountsPerDay[i] ?? 0));
      sandChartData.add(FlSpot(i.toDouble(), (sandTripsPerDay[i] ?? 0).toDouble()));
    }

    return ReportData(
      totalAmount: totalAmount,
      totalWorks: totalWorks,
      totalSandTrips: totalSandTrips,
      amountChartData: amountChartData,
      sandChartData: sandChartData,
      startDate: start,
      endDate: end,
    );
  }
}
