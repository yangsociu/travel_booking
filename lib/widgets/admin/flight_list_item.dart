import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

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
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        flight.departureAirportCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.airplane,
                            size: 24,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            height: 2,
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ],
                      ),
                      Text(
                        flight.arrivalAirportCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.white),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.white),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(flight.departureTime),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  dateFormat.format(flight.arrivalTime),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giá: ${(flight.price / 1000).toStringAsFixed(0)}K',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
