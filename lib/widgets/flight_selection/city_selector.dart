// widgets/flight_selection/city_selector.dart
// Widget chọn thành phố
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/utils/app_theme.dart';

class CitySelector extends StatelessWidget {
  final String label;
  final String? selectedCity;
  final String iconPath;
  final VoidCallback onTap;

  const CitySelector({
    super.key,
    required this.label,
    this.selectedCity,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: AppColors.black,
            ),
            const SizedBox(width: 10),
            Text(
              selectedCity ?? label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
