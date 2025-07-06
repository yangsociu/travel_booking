import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';

class FlightTicketCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onTap;
  final bool isSelected;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  const FlightTicketCard({
    super.key,
    required this.flight,
    this.onTap,
    this.isSelected = false,
    this.scaffoldMessengerKey,
  });

  // Hàm ánh xạ airlineId sang đường dẫn ảnh logo
  String? _getAirlineLogo(String airlineId) {
    switch (airlineId) {
      case 'VN':
        return 'assets/images/vietnam_airlines.png';
      case 'VJ':
        return 'assets/images/vietjet_air.jpg';
      case 'BB':
        return 'assets/images/bamboo_airways.png';
      default:
        return null; // Không có logo cho airlineId không xác định
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);
    final duration = flight.arrivalTime.difference(flight.departureTime);
    final durationText = '${duration.inHours}h ${duration.inMinutes % 60}m';
    final logoPath = _getAirlineLogo(flight.airlineId);

    return GestureDetector(
      onTap: () {
        scaffoldMessengerKey?.currentState?.showSnackBar(
          SnackBar(content: Text('Đã chọn chuyến bay ${flight.id}')),
        );
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : AppColors.white,
              AppColors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : Border.all(color: AppColors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Điểm đi và điểm đến
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
                            Icons.flight_takeoff,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${flight.departureCity} (${flight.departureAirportName})',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey_2,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        departureTime,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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
                                color: AppColors.grey_2,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.flight_land,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        flight.arrivalAirportCode,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Máy bay và thời gian bay
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flight, size: 24, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      durationText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Logo hãng hàng không
            Center(
              child:
                  logoPath != null
                      ? Image.asset(
                        logoPath,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.flight,
                              size: 40,
                              color: AppColors.grey.withOpacity(0.5),
                            ),
                      )
                      : Icon(
                        Icons.flight,
                        size: 40,
                        color: AppColors.grey.withOpacity(0.5),
                      ),
            ),
            const SizedBox(height: 12),
            // Mã chuyến bay và giá vé
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MÃ CHUYẾN',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey_2,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.id,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'GIÁ VÉ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey_2,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(flight.price / 1000).toStringAsFixed(0)}K VND',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Nút chọn vé
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  scaffoldMessengerKey?.currentState?.showSnackBar(
                    SnackBar(content: Text('Đã chọn chuyến bay ${flight.id}')),
                  );
                  if (onTap != null) {
                    onTap!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? AppColors.primaryColor : AppColors.grey,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isSelected ? 5 : 0,
                ),
                child: Text(
                  isSelected ? 'ĐÃ CHỌN' : 'CHỌN VÉ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
