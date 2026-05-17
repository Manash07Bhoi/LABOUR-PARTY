import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../blocs/tractor/tractor_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loaders.dart';
import 'add_tractor_screen.dart';

class TractorScreen extends StatefulWidget {
  const TractorScreen({super.key});

  @override
  State<TractorScreen> createState() => _TractorScreenState();
}

class _TractorScreenState extends State<TractorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TractorBloc>().add(LoadTractorsEvent());
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Tractor', style: AppTypography.titleLarge),
        content: Text('Are you sure you want to remove this tractor?', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TractorBloc>().add(DeleteTractorEvent(id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: Text('Delete', style: AppTypography.labelLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tractors'),
      body: BlocBuilder<TractorBloc, TractorState>(
        builder: (context, state) {
          if (state is TractorLoadingState) {
            return const ListSkeletonLoader();
          } else if (state is TractorEmptyState) {
            return EmptyStateWidget(
              lottieAsset: 'assets/lottie/empty_driver.json',
              title: 'No tractors added',
              actionLabel: 'Add Tractor',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddTractorScreen()),
              ),
            );
          } else if (state is TractorLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TractorBloc>().add(LoadTractorsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: state.tractors.length,
                itemBuilder: (context, index) {
                  final item = state.tractors[index];
                  final tractor = item.tractor;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.agriculture, color: AppColors.warningAmber),
                      ),
                      title: Text(tractor.name, style: AppTypography.titleLarge),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tractor.plateNumber != null && tractor.plateNumber!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(tractor.plateNumber!, style: AppTypography.bodyMedium),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('${item.totalWorks} Works', style: AppTypography.labelLarge),
                              const SizedBox(width: 16),
                              Text('${item.totalSandTrips} Trips', style: AppTypography.labelLarge),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => AddTractorScreen(editTractor: tractor)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                            onPressed: () => _confirmDelete(context, tractor.id),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
                },
              ),
            );
          } else if (state is TractorErrorState) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<TractorBloc>().add(LoadTractorsEvent()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTractorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
