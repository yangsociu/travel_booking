import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/payment/payment_bloc.dart';
import 'package:booking_app/blocs/payment/payment_event.dart';
import 'package:booking_app/blocs/payment/payment_state.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/payment/payment_form.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;
  final String ticketPrice;
  final String duration;

  const PaymentScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
    required this.ticketPrice,
    required this.duration,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  double _calculateTotalPrice() {
    double total = 0;
    for (var seat in widget.selectedSeats) {
      total +=
          int.parse(seat[0]) <= 4
              ? widget.flight.price * 1.5
              : widget.flight.price;
    }
    if (widget.returnFlight != null) {
      for (var seat in widget.returnSelectedSeats) {
        total +=
            int.parse(seat[0]) <= 4
                ? widget.returnFlight!.price * 1.5
                : widget.returnFlight!.price;
      }
    }
    return total;
  }

  String _formatPrice(double price) {
    return '${(price / 1000).toStringAsFixed(0)}K';
  }

  String _calculateFlightDuration(DateTime departure, DateTime arrival) {
    final duration = arrival.difference(departure);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PaymentBloc(flightService: context.read<FlightService>()),
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.paymentSuccess,
              arguments: {
                'flight': widget.flight,
                'passengers': widget.passengers,
                'selectedSeats': widget.selectedSeats,
                'returnFlight': widget.returnFlight,
                'returnSelectedSeats': widget.returnSelectedSeats,
                'totalPrice': _formatPrice(_calculateTotalPrice()),
                'duration': _calculateFlightDuration(
                  widget.flight.departureTime,
                  widget.flight.arrivalTime,
                ),
              },
            );
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.grey_2,
          appBar: AppBar(
            title: const Text(
              'Thanh Toán',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TicketInfoWidget(
                  flight: widget.flight,
                  returnFlight: widget.returnFlight,
                  passengers: widget.passengers,
                  selectedSeats: widget.selectedSeats,
                  returnSelectedSeats: widget.returnSelectedSeats,
                  phoneNumber: widget.phoneNumber,
                  email: widget.email,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Phương thức thanh toán',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                PaymentMethodTile(
                  icon: Icons.credit_card,
                  title: 'Thanh toán qua thẻ',
                  isSelected: _selectedPaymentMethod == 'Card',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Card';
                    });
                  },
                ),
                PaymentMethodTile(
                  icon: Icons.account_balance,
                  title: 'Chuyển khoản ngân hàng',
                  isSelected: _selectedPaymentMethod == 'Bank',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Bank';
                    });
                  },
                ),
                PaymentMethodTile(
                  icon: Icons.account_balance_wallet,
                  title: 'Ví điện tử MoMo',
                  isSelected: _selectedPaymentMethod == 'MoMo',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'MoMo';
                    });
                  },
                ),
                if (_selectedPaymentMethod == 'Card') ...[
                  const SizedBox(height: 20),
                  PaymentForm(
                    flight: widget.flight,
                    returnFlight: widget.returnFlight,
                    passengers: widget.passengers,
                    selectedSeats: widget.selectedSeats,
                    returnSelectedSeats: widget.returnSelectedSeats,
                    phoneNumber: widget.phoneNumber,
                    email: widget.email,
                  ),
                ],
                const SizedBox(height: 20),
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
                        'Chi tiết thanh toán',
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
                            'Tạm tính:',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _formatPrice(_calculateTotalPrice()),
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng thanh toán:',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _formatPrice(_calculateTotalPrice()),
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
                    onPressed:
                        _selectedPaymentMethod == null
                            ? null
                            : () {
                              if (_selectedPaymentMethod != 'Card') {
                                context.read<PaymentBloc>().add(
                                  StartPayment(
                                    flight: widget.flight,
                                    returnFlight: widget.returnFlight,
                                    passengers: widget.passengers,
                                    selectedSeats: widget.selectedSeats,
                                    returnSelectedSeats:
                                        widget.returnSelectedSeats,
                                    phoneNumber: widget.phoneNumber,
                                    email: widget.email,
                                    cardType: '',
                                    cardNumber: '',
                                    cardHolder: '',
                                    expiryDate: '',
                                    cvv: '',
                                  ),
                                );
                              }
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
                      'Xác nhận',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketInfoWidget extends StatelessWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;

  const TicketInfoWidget({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin chuyến đi
          Row(
            children: [
              const Icon(
                CupertinoIcons.airplane,
                color: AppColors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flight.departureCity} (${flight.departureCode}) -> ${flight.arrivalCity} (${flight.arrivalCode})',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(DateTime.now())}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Thời gian bay: ${DateFormat('HH:mm dd MMM yyyy').format(flight.departureTime)}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Thông tin chuyến về (nếu có)
          if (returnFlight != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.airplane,
                  color: AppColors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chuyến về: ${returnFlight!.departureCity} (${returnFlight!.departureCode}) -> ${returnFlight!.arrivalCity} (${returnFlight!.arrivalCode})',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(DateTime.now())}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Thời gian bay: ${DateFormat('HH:mm dd MMM yyyy').format(returnFlight!.departureTime)}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Hành khách & ghế:',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(
              passengers.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chuyến đi: ${passengers[index].fullName} (${selectedSeats[index]})',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                  if (returnFlight != null &&
                      index < returnSelectedSeats.length)
                    Text(
                      'Chuyến về: ${passengers[index].fullName} (${returnSelectedSeats[index]})',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Liên hệ: $phoneNumber',
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          ),
          Text(
            'Email: $email',
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
