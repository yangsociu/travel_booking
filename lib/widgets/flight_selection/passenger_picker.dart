import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class PassengerPicker extends StatelessWidget {
  final int passengerCount;
  final VoidCallback onTap;

  const PassengerPicker({
    super.key,
    required this.passengerCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/date_selection_screen/fluent_guest-add-24-filled.png',
              width: 22,
              height: 22,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              '$passengerCount',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
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
