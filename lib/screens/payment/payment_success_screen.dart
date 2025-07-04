import 'dart:async';
import 'package:flutter/cupertino.dart';
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
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessOverlay();
      _startAutoRedirect();
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
                    Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Thanh toán thành công',
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

    Future.delayed(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _startAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          timer.cancel();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey_2,
      appBar: AppBar(
        title: const Text(
          'Đặt vé thành công',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tổng giá
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng thanh toán',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng giá:',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.totalPrice,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Danh sách vé chuyến đi
              Text(
                'Chuyến đi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
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
                  ticketPrice: ticketPrice,
                  flight: widget.flight,
                  classType: classType,
                  duration: widget.duration,
                );
              }),
              // Danh sách vé chuyến về (nếu có)
              if (widget.returnFlight != null &&
                  widget.returnSelectedSeats.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Chuyến về',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
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
                    ticketPrice: ticketPrice,
                    flight: widget.returnFlight!,
                    classType: classType,
                    duration: widget.duration,
                  );
                }),
              ],
              const SizedBox(height: 20),
              // Nút Trở về và đếm ngược
              Center(
                child: Column(
                  children: [
                    Container(
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
                          _timer?.cancel();
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
                    const SizedBox(height: 8),
                    Text(
                      'Tự động trở về sau $_countdown giây',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.grey,
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
    );
  }

  Widget _buildTicketCard({
    required Passenger passenger,
    required String seat,
    required double ticketPrice,
    required FlightModel flight,
    required String classType,
    required String duration,
  }) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin chuyến bay
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
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${flight.departureCity} (${flight.departureAirportName})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.grey_2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    flight.departureAirportCode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    departureTime,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.airplane,
                size: 24,
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
                          fontSize: 14,
                          color: AppColors.grey_2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        CupertinoIcons.airplane,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    flight.arrivalAirportCode,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    arrivalTime,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Thông tin hành khách và ghế
          Text(
            'Hành khách: ${passenger.fullName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Ghế: $seat',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Hạng vé: $classType',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Giá vé: ${(ticketPrice / 1000).toStringAsFixed(0)}K',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
