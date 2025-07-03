import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/widgets/passenger/passenger_form.dart';
import 'package:booking_app/widgets/passenger/flight_ticket_info.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';

class PassengerInfoScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final int passengerCount;

  const PassengerInfoScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengerCount,
  });

  @override
  _PassengerInfoScreenState createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Thông tin người đặt vé',
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
            FlightTicketInfo(
              flight: widget.flight,
              passengerCount: widget.passengerCount,
            ),
            if (widget.returnFlight != null) ...[
              const SizedBox(height: 20),
              FlightTicketInfo(
                flight: widget.returnFlight!,
                passengerCount: widget.passengerCount,
              ),
            ],
            const SizedBox(height: 20),
            PassengerForm(
              passengerCount: widget.passengerCount, // Đảm bảo dòng này có
              onSubmit: (passengers, phoneNumber, email) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.seatSelection,
                  arguments: {
                    'flight': widget.flight,
                    'returnFlight': widget.returnFlight,
                    'passengers': passengers,
                    'phoneNumber': phoneNumber,
                    'email': email,
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
