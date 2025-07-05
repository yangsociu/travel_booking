// payment_success_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class PaymentSuccessCard extends StatelessWidget {
  final Passenger passenger;
  final String seat;
  final double ticketPrice;
  final FlightModel flight;
  final String classType;
  final String duration;

  const PaymentSuccessCard({
    super.key,
    required this.passenger,
    required this.seat,
    required this.ticketPrice,
    required this.flight,
    required this.classType,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.airplane,
                        size: 22,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${flight.departureCity} (${flight.departureAirportName})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: AppColors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    flight.departureAirportCode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    departureTime,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.airplane,
                size: 26,
                color: AppColors.primaryColor.withOpacity(0.7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '${flight.arrivalCity} (${flight.arrivalAirportName})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: AppColors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        CupertinoIcons.airplane,
                        size: 22,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    flight.arrivalAirportCode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    arrivalTime,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Hành khách: ${passenger.fullName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ghế: $seat',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hạng vé: $classType',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 15,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Giá vé: ${(ticketPrice / 1000).toStringAsFixed(0)}K',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
