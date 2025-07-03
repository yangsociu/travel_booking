import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor = AppColors.white,
    this.borderRadius = 8.0,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.3),
                blurRadius: borderRadius,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );
  }
}
