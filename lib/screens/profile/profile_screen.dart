import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
import 'package:booking_app/widgets/home/custom_bottom_navigation.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    return BlocProvider(
      create:
          (context) =>
              HomeBloc(flightService: FlightService())..add(LoadHomeData()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4FC3F7), Color(0xFFB2EBF2)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 48,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hồ sơ cá nhân',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Thông tin tài khoản của bạn',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontSize: 16, color: AppColors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryColor.withOpacity(
                              0.1,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Email: $userEmail',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Đăng xuất',
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return CustomBottomNavigation(
              currentIndex: state.currentBottomNavIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(SelectBottomNav(index));
                switch (index) {
                  case 0:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                    break;
                  case 1:
                    Navigator.pushNamed(context, AppRoutes.dateSelection);
                    break;
                  case 2:
                    Navigator.pushNamed(context, AppRoutes.ticketHistory);
                    break;
                  case 3:
                    // Ở lại ProfileScreen
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}
