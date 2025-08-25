import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/utils/app_colors.dart';

class SeatGridWidget extends StatelessWidget {
  final Map<String, bool> seats;
  final List<String> selectedSeats;
  final List<Passenger> passengers;
  final bool isReturnFlight;
  final FlightModel flight;
  final Function(String) onSeatSelected;

  SeatGridWidget({
    super.key,
    required this.seats,
    required this.selectedSeats,
    required this.passengers,
    required this.isReturnFlight,
    required this.flight,
    required this.onSeatSelected,
  });

  final List<List<String>> _businessSeats = [
    ['1A', '1B', '1C', '1D'],
    ['2A', '2B', '2C', '2D'],
    ['3A', '3B', '3C', '3D'],
    ['4A', '4B', '4C', '4D'],
  ];

  final List<List<String>> _economySeats = [
    ['5A', '5B', '5C', '5D'],
    ['6A', '6B', '6C', '6D'],
    ['7A', '7B', '7C', '7D'],
    ['8A', '8B', '8C', '8D'],
    ['9A', '9B', '9C', '9D'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chú thích trạng thái ghế
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                Icons.event_seat,
                AppColors.white,
                AppColors.primaryColor,
                'Ghế trống',
              ),
              _buildLegendItem(
                Icons.event_seat,
                AppColors.grey,
                AppColors.primaryColor,
                'Đang chọn',
              ),
              _buildLegendItem(
                Icons.event_seat,
                Colors.yellow[700]!,
                null,
                'Đã đặt',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Hạng thương gia
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Cửa lên máy bay',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Hạng thương gia',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Số hàng
              Column(
                children: List.generate(_businessSeats.length, (index) {
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    // Chữ A B C D
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          ['A', 'B', 'C', 'D'].map((label) {
                            return Text(
                              label,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 8),
                    // Ghế
                    for (var row in _businessSeats)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            row.map((seat) {
                              final isBooked = seats[seat] ?? false;
                              final isSelected = selectedSeats.contains(seat);
                              return GestureDetector(
                                onTap:
                                    isBooked
                                        ? null
                                        : () => onSeatSelected(seat),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isBooked
                                            ? Colors.yellow[700]
                                            : (isSelected
                                                ? AppColors.grey
                                                : AppColors.white),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.event_seat,
                                    color:
                                        isBooked
                                            ? AppColors.black
                                            : AppColors.primaryColor,
                                    size: 24,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Hạng phổ thông
          const Text(
            'Hạng phổ thông',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Số hàng
              Column(
                children: List.generate(_economySeats.length, (index) {
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 5}',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    // Chữ A B C D
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          ['A', 'B', 'C', 'D'].map((label) {
                            return Text(
                              label,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 8),
                    // Ghế
                    for (var row in _economySeats)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            row.map((seat) {
                              final isBooked = seats[seat] ?? false;
                              final isSelected = selectedSeats.contains(seat);
                              return GestureDetector(
                                onTap:
                                    isBooked
                                        ? null
                                        : () => onSeatSelected(seat),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isBooked
                                            ? Colors.yellow[700]
                                            : (isSelected
                                                ? AppColors.grey
                                                : AppColors.white),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.event_seat,
                                    color:
                                        isBooked
                                            ? AppColors.black
                                            : AppColors.primaryColor,
                                    size: 24,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    IconData icon,
    Color backgroundColor,
    Color? borderColor,
    String label,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: backgroundColor,
            border:
                borderColor != null
                    ? Border.all(color: borderColor, width: 2)
                    : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.black,
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
