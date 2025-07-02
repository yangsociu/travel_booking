// payment_screen.dart
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
import 'package:booking_app/widgets/common/custom_text_field.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String? _cardType;
  String _calculateFlightDuration() {
    final duration = widget.flight.arrivalTime.difference(
      widget.flight.departureTime,
    );
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double _calculateTotalPrice() {
    double total = 0;
    // Giá vé chuyến đi
    for (var seat in widget.selectedSeats) {
      total +=
          int.parse(seat[0]) <= 4
              ? widget.flight.price * 1.5
              : widget.flight.price;
    }
    // Giá vé chuyến về (nếu có)
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
                'passengers': widget.passengers, // Truyền toàn bộ passengers
                'selectedSeats': widget.selectedSeats, // Truyền toàn bộ seats
                'returnFlight': widget.returnFlight,
                'returnSelectedSeats': widget.returnSelectedSeats,
                'totalPrice': _formatPrice(
                  _calculateTotalPrice(),
                ), // <-- truyền String
                'duration': _calculateFlightDuration(),
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
              'Thanh toán',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.grey_2,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khung thông tin chuyến bay
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.flight.departureCode,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/flight_selection_screen/ph_dot-duotone.png',
                                  width: 28,
                                  height: 28,
                                  color: AppColors.white,
                                ),
                                Container(
                                  width: 80,
                                  height: 2,
                                  color: AppColors.white,
                                ),
                                Image.asset(
                                  'assets/icons/flight_selection_screen/weui_location-outlined.png',
                                  width: 16,
                                  height: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            widget.flight.arrivalCode,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat(
                          'HH:mm dd MMM yyyy',
                        ).format(widget.flight.departureTime),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: AppColors.white, thickness: 1),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(
                          widget.passengers.length,
                          (index) => Text(
                            'Hành khách: ${widget.passengers[index].firstName} ${widget.passengers[index].lastName} - Ghế: ${widget.selectedSeats[index]}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.returnFlight != null) ...[
                  const SizedBox(height: 20),
                  // Thông tin chuyến về
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.returnFlight!.departureCode,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/flight_selection_screen/ph_dot-duotone.png',
                                    width: 28,
                                    height: 28,
                                    color: AppColors.white,
                                  ),
                                  Container(
                                    width: 80,
                                    height: 2,
                                    color: AppColors.white,
                                  ),
                                  Image.asset(
                                    'assets/icons/flight_selection_screen/weui_location-outlined.png',
                                    width: 16,
                                    height: 16,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.returnFlight!.arrivalCode,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            'HH:mm dd MMM yyyy',
                          ).format(widget.returnFlight!.departureTime),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: AppColors.white, thickness: 1),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(
                            widget.passengers.length,
                            (index) => Text(
                              'Hành khách: ${widget.passengers[index].firstName} ${widget.passengers[index].lastName} - Ghế: ${widget.returnSelectedSeats[index]}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Tiêu đề
                const Text(
                  'Thông tin thanh toán',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // Bảng nhập thông tin
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Loại thẻ',
                            labelStyle: TextStyle(
                              color: AppColors.black,
                              fontFamily: 'Montserrat',
                            ),
                            border: OutlineInputBorder(),
                          ),
                          items:
                              ['Visa', 'MasterCard', 'American Express'].map((
                                String type,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) => _cardType = value,
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Vui lòng chọn loại thẻ'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _cardNumberController,
                          label: 'Số thẻ',
                          keyboardType: TextInputType.number,
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _cardHolderController,
                          label: 'Tên chủ thẻ',
                          keyboardType: TextInputType.text,
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _expiryDateController,
                          label: 'Ngày hết hạn (MM/YY)',
                          keyboardType: TextInputType.datetime,
                          obscureText: false,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: _cvvController,
                          label: 'Mã CVV',
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        // Tổng tiền
                        Text(
                          'Tổng tiền: ${widget.ticketPrice}',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Nút thanh toán
                        BlocBuilder<PaymentBloc, PaymentState>(
                          builder: (context, state) {
                            final isLoading = state is PaymentLoading;
                            return CustomButton(
                              text:
                                  state is PaymentLoading
                                      ? 'Đang xử lý...'
                                      : 'Thanh toán',
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<PaymentBloc>().add(
                                            StartPayment(
                                              flight: widget.flight,
                                              returnFlight: widget.returnFlight,
                                              passengers: widget.passengers,
                                              selectedSeats:
                                                  widget.selectedSeats,
                                              returnSelectedSeats:
                                                  widget.returnSelectedSeats,
                                              phoneNumber: widget.phoneNumber,
                                              email: widget.email,
                                              cardType: _cardType ?? '',
                                              cardNumber:
                                                  _cardNumberController.text,
                                              cardHolder:
                                                  _cardHolderController.text,
                                              expiryDate:
                                                  _expiryDateController.text,
                                              cvv: _cvvController.text,
                                            ),
                                          );
                                        }
                                      },
                            );
                          },
                        ),
                      ],
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
