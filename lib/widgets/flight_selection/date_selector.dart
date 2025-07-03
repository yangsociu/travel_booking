import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final VoidCallback? onTap;
  final bool isEnabled;

  const DateSelector({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onTap,
    required this.isEnabled,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Chọn';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedDate != null;
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
              'assets/icons/date_selection_screen/lets-icons_date-fill.png',
              width: 22,
              height: 22,
              color: isEnabled ? AppColors.primaryColor : AppColors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: ${_formatDate(selectedDate)}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: isSelected && isEnabled ? 16 : 14,
                  color:
                      isSelected && isEnabled
                          ? AppColors.black
                          : AppColors.grey,
                  fontWeight:
                      isSelected && isEnabled
                          ? FontWeight.w600
                          : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isEnabled ? AppColors.primaryColor : AppColors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
