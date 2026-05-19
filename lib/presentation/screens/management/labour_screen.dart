import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/labour/labour_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loaders.dart';
import 'add_labour_screen.dart';

class LabourScreen extends StatefulWidget {
  const LabourScreen({super.key});

  @override
  State<LabourScreen> createState() => _LabourScreenState();
}

class _LabourScreenState extends State<LabourScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LabourBloc>().add(LoadLaboursEvent());
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Labourer', style: AppTypography.titleLarge),
        content: Text('Are you sure you want to remove this labourer?', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<LabourBloc>().add(DeleteLabourEvent(id));
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
      appBar: const CustomAppBar(title: 'Labours'),
      body: BlocBuilder<LabourBloc, LabourState>(
        builder: (context, state) {
          if (state is LabourInitial || state is LabourLoadingState) {
            return const ListSkeletonLoader();
          } else if (state is LabourEmptyState) {
            return EmptyStateWidget(
              lottieAsset: 'assets/lottie/empty_labour.json',
              title: 'No labourers added',
              actionLabel: 'Add Labourer',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddLabourScreen()),
              ),
            );
          } else if (state is LabourLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LabourBloc>().add(LoadLaboursEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: state.labours.length,
                itemBuilder: (context, index) {
                  final item = state.labours[index];
                  final labour = item.labour;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.backgroundSurface,
                        child: Text(
                          labour.name.substring(0, 1).toUpperCase(),
                          style: AppTypography.titleLarge.copyWith(color: AppColors.accentCyanLight),
                        ),
                      ),
                      title: Text(labour.name, style: AppTypography.titleLarge),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (labour.phone != null && labour.phone!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(labour.phone!, style: AppTypography.bodyMedium),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('${item.joinedWorks} Works', style: AppTypography.labelLarge),
                              const SizedBox(width: 16),
                              Text(
                                CurrencyFormatter.format(item.totalEarned),
                                style: AppTypography.labelLarge.copyWith(color: AppColors.successGreen),
                              ),
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
                                MaterialPageRoute(builder: (_) => AddLabourScreen(editLabour: labour)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                            onPressed: () => _confirmDelete(context, labour.id),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
                },
              ),
            );
          } else if (state is LabourErrorState) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<LabourBloc>().add(LoadLaboursEvent()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddLabourScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
