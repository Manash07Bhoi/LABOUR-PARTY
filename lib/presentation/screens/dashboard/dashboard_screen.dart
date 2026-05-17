import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../blocs/work/work_bloc.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/skeleton_loaders.dart';
import '../../widgets/error_state.dart';
import '../work/work_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) {
        return current is WorkLoadingState || 
               current is DashboardLoadedState || 
               current is WorkErrorState;
      },
      builder: (context, state) {
        if (state is WorkInitial) {
          context.read<WorkBloc>().add(LoadDashboardDataEvent());
          return const DashboardSkeletonLoader();
        } else if (state is WorkLoadingState) {
          return const DashboardSkeletonLoader();
        } else if (state is DashboardLoadedState) {
          return _buildDashboardContent(context, state);
        } else if (state is WorkErrorState) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () => context.read<WorkBloc>().add(LoadDashboardDataEvent()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoadedState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WorkBloc>().add(LoadDashboardDataEvent());
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Main Summary Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              blur: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Expenses',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(state.totalSpent),
                    style: AppTypography.displayLarge.copyWith(color: AppColors.accentCyanLight),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(Icons.work_outline, '${state.todayWorksCount}', 'Works'),
                      _buildStatItem(Icons.people_outline, '${state.todayLaboursCount}', 'Labours'),
                      _buildStatItem(Icons.local_shipping_outlined, '${state.totalSandTrips}', 'Trips'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Secondary Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.drive_eta_rounded, color: AppColors.infoBlue),
                        const SizedBox(height: 8),
                        Text(
                          '${state.activeDrivers}',
                          style: AppTypography.headlineMedium,
                        ),
                        Text(
                          'Active Drivers',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.warningAmber),
                        const SizedBox(height: 8),
                        Text(
                          DateFormatter.format(DateTime.now()),
                          style: AppTypography.titleLarge,
                        ),
                        Text(
                          'Today',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Recent Activity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: AppTypography.headlineMedium,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          if (state.recentWorks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'No recent activities',
                  style: AppTypography.bodyMedium,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.recentWorks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final work = state.recentWorks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDeep,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work, color: AppColors.accentCyanLight),
                    ),
                    title: Text(work.workName, style: AppTypography.titleLarge),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(work.placeName, style: AppTypography.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.format(work.date),
                          style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Text(
                      CurrencyFormatter.format(work.totalAmount),
                      style: AppTypography.titleLarge.copyWith(color: AppColors.successGreen),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => WorkDetailScreen(work: work)),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.titleLarge),
        Text(label, style: AppTypography.bodyMedium.copyWith(fontSize: 12)),
      ],
    );
  }
}
