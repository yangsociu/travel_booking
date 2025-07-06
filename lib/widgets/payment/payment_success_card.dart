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

  PaymentSuccessCard({
    super.key,
    required this.passenger,
    required this.seat,
    required this.ticketPrice,
    required this.flight,
    required this.classType,
    required this.duration,
  });

  // Ánh xạ airlineId sang tên hãng
  final Map<String, String> _airlineNames = {
    'VN': 'Vietnam Airlines',
    'VJ': 'VietJet',
    'BB': 'Bamboo Airways',
  };

  // Ánh xạ airlineId sang đường dẫn logo
  String? _getAirlineLogo(String airlineId) {
    switch (airlineId) {
      case 'VN':
        return 'assets/images/vietnam_airlines.png';
      case 'VJ':
        return 'assets/images/vietjet_air.jpg';
      case 'BB':
        return 'assets/images/bamboo_airways.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);
    final airlineName = _airlineNames[flight.airlineId] ?? 'Unknown Airline';
    final logoPath = _getAirlineLogo(flight.airlineId);

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
              Flexible(
                flex: 1,
                child: Column(
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
                        Flexible(
                          child: Text(
                            '${flight.departureCity} (${flight.departureAirportName})',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: AppColors.grey.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
              ),
              Icon(
                CupertinoIcons.airplane,
                size: 26,
                color: AppColors.primaryColor.withOpacity(0.7),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${flight.arrivalCity} (${flight.arrivalAirportName})',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: AppColors.grey.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
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
          Row(
            children: [
              logoPath != null
                  ? Image.asset(
                    logoPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          CupertinoIcons.airplane,
                          size: 40,
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                  )
                  : Icon(
                    CupertinoIcons.airplane,
                    size: 40,
                    color: AppColors.grey.withOpacity(0.5),
                  ),
              const SizedBox(width: 8),
              Text(
                'Hãng: $airlineName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
