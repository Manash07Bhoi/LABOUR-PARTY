import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _confirmClearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear All Data', style: AppTypography.titleLarge.copyWith(color: AppColors.errorRed)),
        content: Text('Are you sure you want to delete all data? This action cannot be undone and will wipe all work records, labours, drivers, tractors, and places.', style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<SettingsBloc>().add(ClearAllDataEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: Text('Clear Data', style: AppTypography.labelLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    bool isDark = true;
                    if (state is SettingsLoadedState) {
                      isDark = state.isDarkMode;
                    }
                    return SwitchListTile(
                      title: Text('Dark Mode', style: AppTypography.titleLarge),
                      subtitle: Text('Toggle application theme', style: AppTypography.bodyMedium),
                      secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.accentCyanLight),
                      value: isDark,
                      activeColor: AppColors.accentCyanLight,
                      onChanged: (val) {
                        context.read<SettingsBloc>().add(ToggleThemeEvent(val));
                      },
                    );
                  },
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.accentCyanLight),
                  title: Text('Language', style: AppTypography.titleLarge),
                  subtitle: Text('English', style: AppTypography.bodyMedium),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Multiple languages coming soon')),
                    );
                  },
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                ListTile(
                  leading: const Icon(Icons.currency_rupee, color: AppColors.accentCyanLight),
                  title: Text('Currency', style: AppTypography.titleLarge),
                  subtitle: Text('INR (₹)', style: AppTypography.bodyMedium),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Multiple currencies coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text('Data Management', style: AppTypography.headlineMedium),
          const SizedBox(height: 16),
          
          GlassCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.errorRed),
              title: Text('Clear All Data', style: AppTypography.titleLarge.copyWith(color: AppColors.errorRed)),
              subtitle: Text('Permanently delete all records', style: AppTypography.bodyMedium),
              onTap: () => _confirmClearData(context),
            ),
          ),
          
          const SizedBox(height: 48),
          
          Center(
            child: Text(
              'Labour Party v1.0.0',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textDisabled),
            ),
          ),
        ],
      ),
    );
  }
}
