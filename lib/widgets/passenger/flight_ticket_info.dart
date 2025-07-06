import 'package:flutter/cupertino.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class FlightTicketInfo extends StatelessWidget {
  final FlightModel flight;
  final int passengerCount;

  const FlightTicketInfo({
    super.key,
    required this.flight,
    required this.passengerCount,
  });

  @override
  Widget build(context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
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
              Flexible(
                flex: 2,
                child: Text(
                  flight.departureAirportCode,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
              Flexible(
                flex: 2,
                child: Text(
                  flight.arrivalAirportCode,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  dateFormat.format(flight.departureTime),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Flexible(
                child: Text(
                  timeFormat.format(flight.departureTime),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
