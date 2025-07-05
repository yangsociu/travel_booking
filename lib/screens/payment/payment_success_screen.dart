import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/payment/payment_success_card.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final FlightModel flight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final FlightModel? returnFlight;
  final List<String> returnSelectedSeats;
  final String totalPrice;
  final String duration;
  final double discountPercentage;

  const PaymentSuccessScreen({
    super.key,
    required this.flight,
    required this.passengers,
    required this.selectedSeats,
    this.returnFlight,
    required this.returnSelectedSeats,
    required this.totalPrice,
    required this.duration,
    required this.discountPercentage,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 26,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Thanh toán thành công',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: AppColors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bạn đã đặt vé thành công cho ${widget.passengers.length} hành khách. Vui lòng kiểm tra email của bạn.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey.withOpacity(0.7),
                              fontFamily: 'Montserrat',
                              fontSize: 14,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Đặt vé thành công',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng thanh toán',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng giá:',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.totalPrice,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (widget.discountPercentage > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Giảm giá:',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${widget.discountPercentage}%',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryColor,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chuyến đi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(widget.passengers.length, (index) {
                final passenger = widget.passengers[index];
                final seat = widget.selectedSeats[index];
                final seatNumber = int.tryParse(seat[0]) ?? 5;
                final basePrice =
                    seatNumber <= 4
                        ? widget.flight.price * 1.5
                        : widget.flight.price;
                final ticketPrice =
                    basePrice * (1 - widget.discountPercentage / 100);
                final classType = seatNumber <= 4 ? 'Thương gia' : 'Phổ thông';
                return PaymentSuccessCard(
                  passenger: passenger,
                  seat: seat,
                  ticketPrice: ticketPrice,
                  flight: widget.flight,
                  classType: classType,
                  duration: widget.duration,
                );
              }),
              if (widget.returnFlight != null &&
                  widget.returnSelectedSeats.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Chuyến về',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(widget.passengers.length, (index) {
                  final passenger = widget.passengers[index];
                  final seat = widget.returnSelectedSeats[index];
                  final seatNumber = int.tryParse(seat[0]) ?? 5;
                  final basePrice =
                      seatNumber <= 4
                          ? widget.returnFlight!.price * 1.5
                          : widget.returnFlight!.price;
                  final ticketPrice =
                      basePrice * (1 - widget.discountPercentage / 100);
                  final classType =
                      seatNumber <= 4 ? 'Thương gia' : 'Phổ thông';
                  return PaymentSuccessCard(
                    passenger: passenger,
                    seat: seat,
                    ticketPrice: ticketPrice,
                    flight: widget.returnFlight!,
                    classType: classType,
                    duration: widget.duration,
                  );
                }),
              ],
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.8),
                          ],
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                    const SizedBox(height: 12),
                    Text(
                      'Tự động trở về sau $_countdown giây',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.grey.withOpacity(0.7),
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
}
