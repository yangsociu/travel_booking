import 'package:flutter/material.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
import 'package:booking_app/widgets/profile/ticket_history_section.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_app/widgets/profile/ticket_history_section.dart';

class ProfileScreen extends StatelessWidget {
  final FlightService flightService;

  const ProfileScreen({super.key, required this.flightService});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.email}, UID: ${user?.uid}');
    if (user != null) {
      user.getIdToken(true).then((token) => print('Refreshed token: $token'));
    } else {
      print('No user logged in, redirecting to login');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      });
    }
    final userEmail = user?.email ?? '';
    print('Using email for query: $userEmail');

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Hồ sơ',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email: $userEmail',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),
              TicketHistorySection(
                userEmail: userEmail,
                flightService: flightService,
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Đăng xuất',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login', // hoặc AppRoutes.login nếu bạn dùng biến route
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
