import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Chào bạn, Hãy bắt đầu hành trình!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: AppColors.primaryColor,
          shadows: [
            Shadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
