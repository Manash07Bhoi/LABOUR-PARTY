import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../../core/constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: blur,
      color: Colors.white.withOpacity(opacity),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.glassWhite,
          Colors.white.withOpacity(0.05),
        ],
      ),
      border: Border.fromBorderSide(BorderSide(
        color: AppColors.glassBorder,
        width: 1,
      )),
      shadowStrength: 4,
      borderRadius: borderRadius != null
          ? (borderRadius as BorderRadius)
          : BorderRadius.circular(20),
      shadowColor: Colors.black.withOpacity(0.25),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
