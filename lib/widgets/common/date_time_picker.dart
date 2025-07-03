import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDateTime;
  final VoidCallback onTap;
  final bool isDateOnly;

  const DateTimePicker({
    super.key,
    required this.label,
    this.selectedDateTime,
    required this.onTap,
    this.isDateOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        selectedDateTime == null
            ? label
            : isDateOnly
            ? selectedDateTime!.toIso8601String().split('T')[0]
            : selectedDateTime!.toIso8601String(),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.black, fontSize: 16),
      ),
      trailing: const Icon(Icons.calendar_today, color: AppColors.black),
      onTap: onTap,
    );
  }
}
