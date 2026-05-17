import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../blocs/place/place_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loaders.dart';
import 'add_place_screen.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlaceBloc>().add(LoadPlacesEvent());
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Place', style: AppTypography.titleLarge),
        content: Text('Are you sure you want to remove this place?', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<PlaceBloc>().add(DeletePlaceEvent(id));
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
    return BlocListener<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state is PlaceDeleteBlockedState) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Cannot Delete', style: AppTypography.titleLarge.copyWith(color: AppColors.warningAmber)),
              content: Text(state.message, style: AppTypography.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('OK', style: AppTypography.labelLarge),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Places'),
        body: BlocBuilder<PlaceBloc, PlaceState>(
          buildWhen: (previous, current) {
            return current is PlaceLoadingState ||
                   current is PlaceLoadedState ||
                   current is PlaceEmptyState ||
                   current is PlaceErrorState;
          },
          builder: (context, state) {
            if (state is PlaceLoadingState) {
              return const ListSkeletonLoader();
            } else if (state is PlaceEmptyState) {
              return EmptyStateWidget(
                lottieAsset: 'assets/lottie/empty_work.json',
                title: 'No places added',
                actionLabel: 'Add Place',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddPlaceScreen()),
                ),
              );
            } else if (state is PlaceLoadedState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PlaceBloc>().add(LoadPlacesEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                  itemCount: state.places.length,
                  itemBuilder: (context, index) {
                    final item = state.places[index];
                    final place = item.place;
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
                          child: const Icon(Icons.place, color: AppColors.infoBlue),
                        ),
                        title: Text(place.name, style: AppTypography.titleLarge),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${item.totalWorks} Works logged here', style: AppTypography.labelLarge),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => AddPlaceScreen(editPlace: place)),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                              onPressed: () => _confirmDelete(context, place.id),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fade(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
                  },
                ),
              );
            } else if (state is PlaceErrorState) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<PlaceBloc>().add(LoadPlacesEvent()),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddPlaceScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
