import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class FlightTicketInfo extends StatelessWidget {
  final FlightModel flight;
  const FlightTicketInfo({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.departureCode,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/flight_selection_screen/ph_dot-duotone.png',
                      width: 28,
                      height: 28,
                      color: AppColors.white,
                    ),
                    Container(height: 2, width: 80, color: AppColors.white),
                    Image.asset(
                      'assets/icons/flight_selection_screen/weui_location-outlined.png',
                      width: 16,
                      height: 16,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              Text(
                flight.arrivalCode,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('HH:mm dd MMM yyyy').format(flight.departureTime),
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.white, thickness: 1),
          const SizedBox(height: 8),
          const Text(
            '1 hành khách',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
