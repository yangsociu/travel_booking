import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/services/hotel_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/profile/past_tickets_section.dart';
import 'package:booking_app/widgets/profile/past_bookings_section.dart';
import 'package:booking_app/widgets/home/custom_bottom_navigation.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketHistoryScreen extends StatelessWidget {
  final FlightService flightService;
  final HotelService hotelService;

  const TicketHistoryScreen({
    super.key,
    required this.flightService,
    required this.hotelService,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? '';
    final userId = user?.uid ?? '';

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
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Icon(
                    Icons.history,
                    size: 48,
                    color: Color.fromARGB(255, 20, 99, 142),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lịch sử đặt vé và phòng',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Xem và quản lý vé máy bay và đặt phòng khách sạn của bạn',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TabBar(
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.primaryColor,
                    tabs: const [
                      Tab(text: 'Vé máy bay'),
                      Tab(text: 'Đặt phòng'),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TabBarView(
                        children: [
                          PastTicketsSection(
                            userEmail: userEmail,
                            flightService: flightService,
                          ),
                          PastBookingsSection(
                            userId: userId,
                            hotelService: hotelService,
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
                    // Ở lại TicketHistoryScreen
                    break;
                  case 3:
                    Navigator.pushNamed(context, AppRoutes.profile);
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
