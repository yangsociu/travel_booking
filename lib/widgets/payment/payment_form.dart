// payment_form.dart
import 'package:booking_app/blocs/payment/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/payment/payment_bloc.dart';
import 'package:booking_app/blocs/payment/payment_event.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_text_field.dart';
import 'package:booking_app/widgets/common/custom_button.dart';

class PaymentForm extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;
  final double discountPercentage;

  const PaymentForm({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
    required this.discountPercentage,
  });

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String? _cardType;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  ['Visa', 'MasterCard', 'American Express'].map((String type) {
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
                  (value) => value == null ? 'Vui lòng chọn loại thẻ' : null,
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
            BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                final isLoading = state is PaymentLoading;
                return CustomButton(
                  text: isLoading ? 'Đang xử lý...' : 'Xác nhận thanh toán',
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
                                  selectedSeats: widget.selectedSeats,
                                  returnSelectedSeats:
                                      widget.returnSelectedSeats,
                                  phoneNumber: widget.phoneNumber,
                                  email: widget.email,
                                  cardType: _cardType ?? '',
                                  cardNumber: _cardNumberController.text,
                                  cardHolder: _cardHolderController.text,
                                  expiryDate: _expiryDateController.text,
                                  cvv: _cvvController.text,
                                  discountPercentage: widget.discountPercentage,
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
    );
  }
}
