// widgets/flight_selection/round_trip_switch.dart
// Widget công tắc khứ hồi
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/utils/app_theme.dart';

class RoundTripSwitch extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool> onChanged;

  const RoundTripSwitch({
    super.key,
    required this.isRoundTrip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Khứ hồi',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        Switch(
          value: isRoundTrip,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
          inactiveTrackColor: AppColors.black,
        ),
      ],
    );
  }
}
