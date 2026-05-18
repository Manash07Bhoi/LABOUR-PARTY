import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/reports/reports_bloc.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/glass_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isWeekly = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (_isWeekly) {
      context.read<ReportsBloc>().add(LoadWeeklyReportEvent(endDate: DateTime.now()));
    } else {
      final now = DateTime.now();
      context.read<ReportsBloc>().add(LoadMonthlyReportEvent(year: now.year, month: now.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Period Toggle
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  title: 'This Week',
                  isSelected: _isWeekly,
                  onTap: () {
                    setState(() {
                      _isWeekly = true;
                    });
                    _loadData();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildToggleButton(
                  title: 'This Month',
                  isSelected: !_isWeekly,
                  onTap: () {
                    setState(() {
                      _isWeekly = false;
                    });
                    _loadData();
                  },
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReportsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReportsEmptyState) {
                return const EmptyStateWidget(
                  lottieAsset: 'assets/lottie/no_report.json',
                  title: 'No data for this period',
                );
              } else if (state is ReportsLoadedState) {
                return _buildReportContent(state);
              } else if (state is ReportsErrorState) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: _loadData,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({required String title, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyanLight.withOpacity(0.2) : AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentCyanLight : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            color: isSelected ? AppColors.accentCyanLight : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent(ReportsLoadedState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Summary GlassCard
        GlassCard(
          child: Column(
            children: [
              Text(
                _isWeekly ? 'Weekly Summary' : 'Monthly Summary',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.format(state.reportData.totalAmount),
                style: AppTypography.displayLarge.copyWith(color: AppColors.accentCyanLight),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('${state.reportData.totalWorks}', style: AppTypography.titleLarge),
                      Text('Total Works', style: AppTypography.bodyMedium),
                    ],
                  ),
                  Container(height: 40, width: 1, color: AppColors.glassBorder),
                  Column(
                    children: [
                      Text('${state.reportData.totalSandTrips}', style: AppTypography.titleLarge),
                      Text('Sand Trips', style: AppTypography.bodyMedium),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        Text('Expenses Trend', style: AppTypography.headlineMedium),
        const SizedBox(height: 24),
        
        // Chart
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _isWeekly
            ? BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final keys = state.chartMap.keys.toList();
                          if (value.toInt() >= 0 && value.toInt() < keys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                keys[value.toInt()],
                                style: AppTypography.bodyMedium.copyWith(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text(
                            NumberFormat.compactCurrency(symbol: '₹').format(value),
                            style: AppTypography.bodyMedium.copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(state.chartMap),
                ),
              )
            : LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // For monthly, only show every 5th day to avoid crowding
                          if (value.toInt() % 5 == 0) {
                            final keys = state.chartMap.keys.toList();
                            if (value.toInt() >= 0 && value.toInt() < keys.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  keys[value.toInt()],
                                  style: AppTypography.bodyMedium.copyWith(fontSize: 10),
                                ),
                              );
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text(
                            NumberFormat.compactCurrency(symbol: '₹').format(value),
                            style: AppTypography.bodyMedium.copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: state.chartMap.length.toDouble() - 1,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildLineSpots(state.chartMap),
                      isCurved: true,
                      color: AppColors.accentCyanLight,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentCyanLight.withOpacity(0.5),
                            AppColors.accentCyanLight.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, double> chartMap) {
    int x = 0;
    return chartMap.entries.map((entry) {
      final barGroup = BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AppColors.accentCyanLight,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
      x++;
      return barGroup;
    }).toList();
  }

  List<FlSpot> _buildLineSpots(Map<String, double> chartMap) {
    int x = 0;
    return chartMap.entries.map((entry) {
      final spot = FlSpot(x.toDouble(), entry.value);
      x++;
      return spot;
    }).toList();
  }
}
