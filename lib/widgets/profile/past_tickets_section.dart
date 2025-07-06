import 'package:flutter/material.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class PastTicketsSection extends StatelessWidget {
  final String userEmail;
  final FlightService flightService;

  PastTicketsSection({
    super.key,
    required this.userEmail,
    required this.flightService,
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
    return FutureBuilder<List<Ticket>>(
      future: flightService.getUserTickets(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error loading tickets: ${snapshot.error}');
          return Center(child: Text('Lỗi khi tải vé: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No tickets found for user: $userEmail');
          return const Center(child: Text('Chưa có vé nào.'));
        }

        final tickets = snapshot.data!;
        print('Loaded ${tickets.length} tickets for user: $userEmail');
        for (var ticket in tickets) {
          print(
            'Ticket: ${ticket.flight.id}, Seat: ${ticket.seat}, Booking Time: ${ticket.bookingTime}',
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            final classType =
                ((int.tryParse(ticket.seat[0]) ?? 5) <= 4)
                    ? 'Thương gia'
                    : 'Phổ thông';
            final airlineName =
                _airlineNames[ticket.flight.airlineId] ?? 'Unknown Airline';
            final logoPath = _getAirlineLogo(ticket.flight.airlineId);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã chuyến bay: ${ticket.flight.id}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
                                  Icons.airplane_ticket,
                                  size: 40,
                                  color: AppColors.grey.withOpacity(0.5),
                                ),
                          )
                          : Icon(
                            Icons.airplane_ticket,
                            size: 40,
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                      const SizedBox(width: 8),
                      Text(
                        'Hãng: $airlineName',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ticket.flight.departureCity} (${ticket.flight.departureAirportCode}) - ${ticket.flight.arrivalCity} (${ticket.flight.arrivalAirportCode})',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hành khách: ${ticket.passenger.fullName}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ghế: ${ticket.seat} ($classType)',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giá vé: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(ticket.ticketPrice)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(ticket.bookingTime)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
