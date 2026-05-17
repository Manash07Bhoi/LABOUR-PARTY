import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'About'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.build, size: 120, color: AppColors.accentCyanLight),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Labour Party',
              style: AppTypography.displayLarge,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Version 1.0.0',
              style: AppTypography.bodyMedium,
            ),
          ),
          const SizedBox(height: 32),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About the App', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                Text(
                  'Labour Party is a professional offline operational management tool for tracking daily labour works, payments, drivers, tractors, and sand trips.',
                  style: AppTypography.bodyLarge.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'All data is stored securely on your device. No internet connection is required to use this application.',
                  style: AppTypography.bodyLarge.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
