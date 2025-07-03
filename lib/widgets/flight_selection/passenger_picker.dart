import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_card.dart';
import 'package:booking_app/widgets/common/icon_text_row.dart';

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
      child: CustomCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: IconTextRow(
          iconPath:
              'assets/icons/date_selection_screen/fluent_guest-add-24-filled.png',
          text: 'Số khách: $passengerCount',
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
