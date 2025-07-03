import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_card.dart';
import 'package:booking_app/widgets/common/icon_text_row.dart';

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
      child: CustomCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: IconTextRow(
          iconPath: iconPath,
          text: selectedCity ?? label,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            color: AppColors.black,
          ),
          iconWidth: 24,
          iconHeight: 24,
          iconColor: AppColors.black,
          spacing: 10,
        ),
      ),
    );
  }
}
