import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../blocs/driver/driver_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loaders.dart';
import 'add_driver_screen.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DriverBloc>().add(LoadDriversEvent());
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Driver', style: AppTypography.titleLarge),
        content: Text('Are you sure you want to remove this driver?', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<DriverBloc>().add(DeleteDriverEvent(id));
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
      appBar: const CustomAppBar(title: 'Drivers'),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state is DriverInitial || state is DriverLoadingState) {
            return const ListSkeletonLoader();
          } else if (state is DriverEmptyState) {
            return EmptyStateWidget(
              lottieAsset: 'assets/lottie/empty_driver.json',
              title: 'No drivers added',
              actionLabel: 'Add Driver',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddDriverScreen()),
              ),
            );
          } else if (state is DriverLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DriverBloc>().add(LoadDriversEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                itemCount: state.drivers.length,
                itemBuilder: (context, index) {
                  final item = state.drivers[index];
                  final driver = item.driver;
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
                        child: const Icon(Icons.person, color: AppColors.infoBlue),
                      ),
                      title: Text(driver.name, style: AppTypography.titleLarge),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (driver.phone != null && driver.phone!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(driver.phone!, style: AppTypography.bodyMedium),
                          ],
                          const SizedBox(height: 8),
                          Text('${item.totalWorks} Works Completed', style: AppTypography.labelLarge),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => AddDriverScreen(editDriver: driver)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                            onPressed: () => _confirmDelete(context, driver.id),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
                },
              ),
            );
          } else if (state is DriverErrorState) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<DriverBloc>().add(LoadDriversEvent()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddDriverScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
