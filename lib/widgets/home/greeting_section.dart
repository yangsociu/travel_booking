// widgets/home/greeting_section.dart
// Widget hiển thị lời chào
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ), // Tăng giãn cách trên/dưới
      child: Text(
        'Chào bạn, Hãy bắt đầu hành trình!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.15,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
