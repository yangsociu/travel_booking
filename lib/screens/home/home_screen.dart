import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/home/custom_bottom_navigation.dart';
import 'package:booking_app/widgets/home/flight_search_bar.dart';
import 'package:booking_app/widgets/home/greeting_section.dart';
import 'package:booking_app/widgets/home/discount_banner_list.dart';
import 'package:booking_app/widgets/home/hot_destinations.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/home/home_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flightService = FlightService();

    return BlocProvider(
      create:
          (context) =>
              HomeBloc(flightService: flightService)..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GreetingSection(),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: FlightSearchBar(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade100, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavIcon(
                                context,
                                icon: Icons.flight_takeoff,
                                label: 'Flights',
                                isSelected: state.selectedNavIconIndex == 0,
                                onTap:
                                    () => context.read<HomeBloc>().add(
                                      SelectNavIcon(0),
                                    ),
                              ),
                              _buildNavIcon(
                                context,
                                icon: Icons.hotel,
                                label: 'Hotels',
                                isSelected: state.selectedNavIconIndex == 1,
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                    SelectNavIcon(1),
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.hotelList,
                                  );
                                },
                              ),
                              _buildNavIcon(
                                context,
                                icon: Icons.directions_car,
                                label: 'Cars',
                                isSelected: state.selectedNavIconIndex == 2,
                                onTap:
                                    () => context.read<HomeBloc>().add(
                                      SelectNavIcon(2),
                                    ),
                              ),
                              _buildNavIcon(
                                context,
                                icon: Icons.beach_access,
                                label: 'More',
                                isSelected: state.selectedNavIconIndex == 3,
                                onTap:
                                    () => context.read<HomeBloc>().add(
                                      SelectNavIcon(3),
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          spreadRadius: 1,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: DiscountBannerList(flightService: flightService),
                    ),
                  ),
                  const SizedBox(height: 36),
                  const HotDestinations(),
                  const SizedBox(height: 32),
                  const HomeFooter(),
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
                    break;
                  case 1:
                    Navigator.pushNamed(context, AppRoutes.dateSelection);
                    break;
                  case 2:
                    Navigator.pushNamed(context, AppRoutes.ticketHistory);
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

  Widget _buildNavIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primaryColor.withAlpha(20)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
