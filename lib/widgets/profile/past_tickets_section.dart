import 'package:flutter/material.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class PastTicketsSection extends StatelessWidget {
  final String userEmail;
  final FlightService flightService;

  const PastTicketsSection({
    super.key,
    required this.userEmail,
    required this.flightService,
  });

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
          physics: const ClampingScrollPhysics(), // Bật cuộn
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            final classType =
                ((int.tryParse(ticket.seat[0]) ?? 5) <= 4)
                    ? 'Thương gia'
                    : 'Phổ thông';
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ticket.flight.departureCity} (${ticket.flight.departureAirportCode}) - ${ticket.flight.arrivalCity} (${ticket.flight.arrivalAirportCode})',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hành khách: ${ticket.passenger.fullName}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ghế: ${ticket.seat} ($classType)',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giá vé: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(ticket.ticketPrice)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(ticket.bookingTime)}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
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
