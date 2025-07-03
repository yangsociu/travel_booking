import 'package:flutter/material.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class TicketListItem extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onDelete;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  const TicketListItem({
    super.key,
    required this.ticket,
    required this.onDelete,
    this.scaffoldMessengerKey,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vé #${ticket.id}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.grey),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Chuyến bay: ${ticket.flight.id}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Điểm đi: ${ticket.flight.departureCity} (${ticket.flight.departureCode})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Điểm đến: ${ticket.flight.arrivalCity} (${ticket.flight.arrivalCode})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hành khách: ${ticket.passenger.fullName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ghế: ${ticket.seat}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thời gian đặt: ${dateFormat.format(ticket.bookingTime)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tổng giá: ${(ticket.ticketPrice / 1000).toStringAsFixed(0)}K',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Số điện thoại: ${ticket.phoneNumber}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${ticket.email}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
