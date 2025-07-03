import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_card.dart';

class FlightListItem extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FlightListItem({
    super.key,
    required this.flight,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16.0),
      borderRadius: 12.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.id,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.grey),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${flight.departureCity} (${flight.departureCode}) → ${flight.arrivalCity} (${flight.arrivalCode})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thời gian: ${flight.departureTime.toIso8601String()} - ${flight.arrivalTime.toIso8601String()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Giá: ${(flight.price / 1000).toStringAsFixed(0)}K',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
