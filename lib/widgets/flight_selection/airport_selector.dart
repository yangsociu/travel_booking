import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class AirportSelector extends StatelessWidget {
  final String label;
  final String? airportName;
  final String? airportCode;

  const AirportSelector({
    super.key,
    required this.label,
    this.airportName,
    this.airportCode,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = airportName != null && airportCode != null;
    final displayText = isSelected ? '$airportName ($airportCode)' : label;

    return Container(
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
            'assets/icons/date_selection_screen/tdesign_location-filled.png',
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
        ],
      ),
    );
  }
}
