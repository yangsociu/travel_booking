import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final FlightModel flight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final FlightModel? returnFlight;
  final List<String> returnSelectedSeats;
  final String totalPrice;
  final String duration;

  const PaymentSuccessScreen({
    super.key,
    required this.flight,
    required this.passengers,
    required this.selectedSeats,
    this.returnFlight,
    required this.returnSelectedSeats,
    required this.totalPrice,
    required this.duration,
  });

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessOverlay();
    });
  }

  void _showSuccessOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/lets-icons_check-fill.png',
                      width: 24,
                      height: 24,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Thành công',
                            style: TextStyle(
                              color: AppColors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bạn đã đặt vé thành công cho ${widget.passengers.length} hành khách. Vui lòng kiểm tra email của bạn.',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tổng giá
              Text(
                'Tổng giá: ${widget.totalPrice}',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              // Danh sách vé chuyến đi
              Text(
                'Chuyến đi: ${widget.flight.departureCity} - ${widget.flight.arrivalCity}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(widget.passengers.length, (index) {
                final passenger = widget.passengers[index];
                final seat = widget.selectedSeats[index];
                final seatNumber = int.tryParse(seat[0]) ?? 5;
                final ticketPrice =
                    seatNumber <= 4
                        ? widget.flight.price * 1.5
                        : widget.flight.price;
                final classType = seatNumber <= 4 ? 'Thương gia' : 'Phổ thông';
                return _buildTicketCard(
                  passenger: passenger,
                  seat: seat,
                  ticketPrice: ticketPrice.toString(),
                  flight: widget.flight,
                  classType: classType,
                  duration: widget.duration,
                );
              }),
              // Danh sách vé chuyến về (nếu có)
              if (widget.returnFlight != null &&
                  widget.returnSelectedSeats.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Chuyến về: ${widget.returnFlight!.departureCity} - ${widget.returnFlight!.arrivalCity}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(widget.passengers.length, (index) {
                  final passenger = widget.passengers[index];
                  final seat = widget.returnSelectedSeats[index];
                  final seatNumber = int.tryParse(seat[0]) ?? 5;
                  final ticketPrice =
                      seatNumber <= 4
                          ? widget.returnFlight!.price * 1.5
                          : widget.returnFlight!.price;
                  final classType =
                      seatNumber <= 4 ? 'Thương gia' : 'Phổ thông';
                  return _buildTicketCard(
                    passenger: passenger,
                    seat: seat,
                    ticketPrice: ticketPrice.toString(),
                    flight: widget.returnFlight!,
                    classType: classType,
                    duration: widget.duration,
                  );
                }),
              ],
              const SizedBox(height: 20),
              // Nút Trở về
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Trở về',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard({
    required Passenger passenger,
    required String seat,
    required String ticketPrice,
    required FlightModel flight,
    required String classType,
    required String duration,
  }) {
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cột trái: Giá vé, số ghế
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$ticketPrice',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ghế: $seat',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hành khách: ${passenger.fullName}',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Cột phải: Thông tin chuyến bay
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${flight.departureCity} - ${flight.arrivalCity}',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${flight.departureCode} - ${flight.arrivalCode}',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'HH:mm dd MMM yyyy',
                      ).format(flight.departureTime),
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thời gian bay: $duration',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hạng vé: $classType',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider nét đứt
          Container(
            height: 1,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.black,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: CustomPaint(painter: DashedLinePainter()),
          ),
          const SizedBox(height: 16),
          // Mã chuyến bay
          Text(
            'Mã chuyến bay: ${flight.id}',
            style: const TextStyle(
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Mã vạch
          Image.asset(
            'assets/images/ma_vach.png',
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// Painter để vẽ đường nét đứt
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
