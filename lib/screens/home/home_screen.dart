import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/home/custom_bottom_navigation.dart';
import 'package:booking_app/widgets/home/flight_search_bar.dart';
import 'package:booking_app/widgets/home/greeting_section.dart';
import 'package:booking_app/widgets/home/navigation_icons.dart';
import 'package:booking_app/widgets/home/discount_banner.dart';
import 'package:booking_app/widgets/home/hot_destinations.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomeBloc(flightService: FlightService())..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GreetingSection(),
                const SizedBox(height: 28),
                const FlightSearchBar(),
                const SizedBox(height: 28),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return NavigationIcons(
                      selectedIndex: state.selectedNavIconIndex,
                      onIconSelected: (index) {
                        context.read<HomeBloc>().add(SelectNavIcon(index));
                      },
                    );
                  },
                ),
                const SizedBox(height: 36),
                const DiscountBanner(),
                const SizedBox(height: 36),
                const HotDestinations(),
              ],
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
                    // Ở lại HomeScreen
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
}
