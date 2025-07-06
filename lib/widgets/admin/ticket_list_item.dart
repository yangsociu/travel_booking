import 'package:flutter/material.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class TicketListItem extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onDelete;

  const TicketListItem({
    super.key,
    required this.ticket,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final classType =
        (int.tryParse(ticket.seat[0]) ?? 5) <= 4 ? 'Thương gia' : 'Phổ thông';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A2A), // Tông tối hơn cho gradient
              const Color(0xFF1E1E1E).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã vé: ${ticket.id}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.95), // Tăng độ tương phản
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Chuyến bay: ${ticket.flight.departureCity} → ${ticket.flight.arrivalCity}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.9), // Tăng độ tương phản
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hành khách: ${ticket.passenger.fullName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.9),
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ghế: ${ticket.seat} ($classType)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.9),
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(ticket.ticketPrice)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor.withOpacity(
                  0.95,
                ), // Tăng độ tương phản
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(ticket.bookingTime)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.9),
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.grey, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Chỉ giữ nút Xóa ở bên phải
              children: [
                TextButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            backgroundColor: const Color(0xFF1E1E1E),
                            title: Text(
                              'Xác nhận xóa',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: AppColors.white.withOpacity(0.95),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            content: Text(
                              'Bạn có chắc chắn muốn xóa vé này?',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white.withOpacity(0.95),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () =>
                                        Navigator.of(dialogContext).pop(false),
                                child: Text(
                                  'Hủy',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.grey.withOpacity(0.9),
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(true),
                                child: Text(
                                  'Xóa',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      onDelete();
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Xóa',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.redAccent,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
