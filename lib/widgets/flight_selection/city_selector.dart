import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

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
    final isSelected = selectedCity != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey_2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedCity ?? label,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: isSelected ? 16 : 14,
                  color: isSelected ? AppColors.black : AppColors.primaryColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
