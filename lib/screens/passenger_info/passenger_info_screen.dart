import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/widgets/passenger/passenger_form.dart';
import 'package:booking_app/widgets/passenger/flight_ticket_info.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class PassengerInfoScreen extends StatefulWidget {
  final FlightModel flight;

  const PassengerInfoScreen({super.key, required this.flight});

  @override
  _PassengerInfoScreenState createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _birthYearController = TextEditingController();
  String? _gender;
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _birthYearController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
            FlightTicketInfo(flight: widget.flight), // <-- Thêm dòng này ở đây
            const SizedBox(height: 20),
            // Thay phần Container chứa Form bằng:
            PassengerForm(
              onSubmit: (passenger) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.seatSelection,
                  arguments: {'flight': widget.flight, 'passenger': passenger},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
