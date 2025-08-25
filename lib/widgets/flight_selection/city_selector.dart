import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class CitySelector extends StatelessWidget {
  final String label;
  final String? selectedCity;
  final String? selectedAirportName;
  final String? selectedAirportCode;
  final String iconPath;
  final VoidCallback onTap;

  const CitySelector({
    super.key,
    required this.label,
    this.selectedCity,
    this.selectedAirportName,
    this.selectedAirportCode,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedCity != null;
    final displayText = isSelected ? selectedCity! : label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: isSelected ? AppColors.black : AppColors.grey_2,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
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
