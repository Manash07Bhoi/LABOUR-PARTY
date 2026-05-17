import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/work.dart';
import '../../blocs/work/work_bloc.dart';
import '../../blocs/labour/labour_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';
import 'add_work_screen.dart';

class WorkDetailScreen extends StatelessWidget {
  final Work work;

  const WorkDetailScreen({super.key, required this.work});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Work Record', style: AppTypography.titleLarge),
        content: Text('Are you sure you want to delete this record? This action cannot be undone.', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<WorkBloc>().add(DeleteWorkEvent(work.id));
              Navigator.of(context).pop();
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
      appBar: CustomAppBar(
        title: 'Work Detail',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AddWorkScreen(editWork: work)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Summary Card
          GlassCard(
            blur: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        work.workName,
                        style: AppTypography.headlineLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyanLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormatter.format(work.date),
                        style: AppTypography.labelLarge.copyWith(color: AppColors.accentCyanLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Text(work.placeName, style: AppTypography.titleLarge),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: AppTypography.bodyLarge),
                    Text(
                      CurrencyFormatter.format(work.totalAmount),
                      style: AppTypography.moneyDisplay.copyWith(color: AppColors.successGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount per Labour', style: AppTypography.bodyMedium),
                    Text(
                      CurrencyFormatter.format(work.labourCount > 0 ? work.totalAmount / work.labourCount : 0.0),
                      style: AppTypography.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ).animate().slideY(begin: 0.1, end: 0).fade(),
          
          const SizedBox(height: 24),
          
          // Vehicle Info
          if (work.driverName != null || work.tractorName != null || work.sandTrips > 0) ...[
            Text('Vehicle Details', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (work.driverName != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text('Driver: ', style: AppTypography.bodyMedium),
                        Text(work.driverName!, style: AppTypography.bodyLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (work.tractorName != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.agriculture_outlined, color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text('Tractor: ', style: AppTypography.bodyMedium),
                        Text(work.tractorName!, style: AppTypography.bodyLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Text('Sand Trips: ', style: AppTypography.bodyMedium),
                      Text('${work.sandTrips}', style: AppTypography.titleLarge),
                    ],
                  ),
                ],
              ),
            ).animate(delay: 100.ms).slideY(begin: 0.1, end: 0).fade(),
            const SizedBox(height: 24),
          ],
          
          // Labours List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Labours (${work.labourCount})', style: AppTypography.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<LabourBloc, LabourState>(
            builder: (context, state) {
              if (state is LabourLoadedState) {
                // Filter the labours that are part of this work
                final workLabours = state.labours
                    .where((l) => work.labourIds.contains(l.labour.id))
                    .toList();
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workLabours.length,
                  itemBuilder: (context, index) {
                    final labour = workLabours[index].labour;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.backgroundSurface,
                          child: Text(
                            labour.name.substring(0, 1).toUpperCase(),
                            style: AppTypography.titleLarge.copyWith(color: AppColors.accentCyanLight),
                          ),
                        ),
                        title: Text(labour.name, style: AppTypography.bodyLarge),
                        trailing: Text(
                          CurrencyFormatter.format(work.labourCount > 0 ? work.totalAmount / work.labourCount : 0.0),
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.accentCyanLight),
                        ),
                      ),
                    ).animate(delay: (200 + (index * 50)).ms).fade().slideX(begin: 0.1, end: 0);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
