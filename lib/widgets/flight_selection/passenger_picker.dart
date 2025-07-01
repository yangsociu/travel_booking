// widgets/flight_selection/passenger_picker.dart
// Widget chọn số khách
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/utils/app_theme.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/date_selection_screen/fluent_guest-add-24-filled.png',
              width: 24,
              height: 24,
              color: AppColors.black,
            ),
            const SizedBox(width: 10),
            Text(
              'Số khách: $passengerCount',
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
