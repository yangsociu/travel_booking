// flight_selection_screen.dart
// screens/flight_selection/flight_selection_screen.dart
// Màn hình chọn chuyến bay
import 'package:booking_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_bloc.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_event.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/flight_selection/flight_ticket_card.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/utils/app_theme.dart';

class FlightSelectionScreen extends StatelessWidget {
  final String? departureCity;
  final String? arrivalCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengerCount;

  const FlightSelectionScreen({
    super.key,
    this.departureCity,
    this.arrivalCity,
    required this.departureDate,
    this.returnDate,
    required this.passengerCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FlightSelectionBloc(flightService: FlightService())..add(
            LoadFlights(
              departureCity: departureCity ?? '',
              arrivalCity: arrivalCity ?? '',
              departureDate: departureDate,
            ),
          ),
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: AppBar(
          title: Text(
            'Chọn chuyến bay',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.grey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<FlightSelectionBloc, FlightSelectionState>(
          builder: (context, state) {
            if (state is FlightSelectionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FlightSelectionLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    state.flights.isEmpty
                        ? Center(
                          child: Text(
                            'Không tìm thấy chuyến bay nào.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: state.flights.length,
                          itemBuilder: (context, index) {
                            final flight = state.flights[index];
                            return FlightTicketCard(
                              flight: flight,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.passengerInfo,
                                  arguments: {'flight': flight},
                                );
                              },
                            );
                          },
                        ),
              );
            } else if (state is FlightSelectionError) {
              return Center(
                child: Text(
                  'Lỗi: ${state.message}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                'Khởi tạo...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
