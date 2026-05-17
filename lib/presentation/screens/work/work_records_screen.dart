import 'add_work_screen.dart';

import 'work_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../blocs/work/work_bloc.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loaders.dart';

class WorkRecordsScreen extends StatefulWidget {
  const WorkRecordsScreen({super.key});

  @override
  State<WorkRecordsScreen> createState() => _WorkRecordsScreenState();
}

class _WorkRecordsScreenState extends State<WorkRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // In real usage, this might be triggered initially by MainShell
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<WorkBloc>().add(SearchWorksEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search works or places...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<WorkBloc, WorkState>(
            buildWhen: (previous, current) {
              return current is WorkLoadingState || 
                     current is WorkListLoadedState || 
                     current is WorkEmptyState || 
                     current is WorkErrorState;
            },
            builder: (context, state) {
              if (state is WorkLoadingState) {
                return const ListSkeletonLoader();
              } else if (state is WorkEmptyState) {
                return EmptyStateWidget(
                  lottieAsset: 'assets/lottie/empty_work.json',
                  title: _searchController.text.isNotEmpty ? 'No results found' : 'No work records yet',
                  actionLabel: _searchController.text.isNotEmpty ? 'Clear Search' : 'Add Work',
                  onAction: () {
                    if (_searchController.text.isNotEmpty) {
                      _searchController.clear();
                      _onSearchChanged('');
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddWorkScreen()));
                    }
                  },
                );
              } else if (state is WorkListLoadedState) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<WorkBloc>().add(LoadAllWorksEvent());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                    itemCount: state.works.length,
                    itemBuilder: (context, index) {
                      final work = state.works[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => WorkDetailScreen(work: work)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        work.workName,
                                        style: AppTypography.titleLarge,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      DateFormatter.format(work.date),
                                      style: AppTypography.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        work.placeName,
                                        style: AppTypography.bodyMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(color: AppColors.glassBorder),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.people_outline, size: 18, color: AppColors.accentCyanLight),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${work.labourCount} Labours',
                                          style: AppTypography.labelLarge,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      CurrencyFormatter.format(work.totalAmount),
                                      style: AppTypography.titleLarge.copyWith(color: AppColors.successGreen),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fade(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
                    },
                  ),
                );
              } else if (state is WorkErrorState) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => context.read<WorkBloc>().add(LoadAllWorksEvent()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
