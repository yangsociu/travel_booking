import 'package:booking_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_bloc.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_event.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/flight_selection/flight_ticket_card.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/models/flight_model.dart';

class FlightSelectionScreen extends StatefulWidget {
  final String? departureCity;
  final String? arrivalCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengerCount;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  FlightSelectionScreen({
    super.key,
    this.departureCity,
    this.arrivalCity,
    required this.departureDate,
    this.returnDate,
    required this.passengerCount,
  });

  @override
  _FlightSelectionScreenState createState() => _FlightSelectionScreenState();
}

class _FlightSelectionScreenState extends State<FlightSelectionScreen> {
  FlightModel? selectedDepartureFlight;
  FlightModel? selectedReturnFlight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FlightSelectionBloc(flightService: FlightService())..add(
            LoadFlights(
              departureCity: widget.departureCity ?? '',
              arrivalCity: widget.arrivalCity ?? '',
              departureDate: widget.departureDate,
              returnDate: widget.returnDate,
            ),
          ),
      child: ScaffoldMessenger(
        key: widget.scaffoldMessengerKey,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chuyến đi
                      Text(
                        'Chuyến đi: ${widget.departureCity} → ${widget.arrivalCity}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      state.departureFlights.isEmpty
                          ? Center(
                            child: Text(
                              'Không tìm thấy chuyến bay đi.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                            ),
                          )
                          : Expanded(
                            child: ListView.builder(
                              itemCount: state.departureFlights.length,
                              itemBuilder: (context, index) {
                                final flight = state.departureFlights[index];
                                return FlightTicketCard(
                                  flight: flight,
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        selectedDepartureFlight = flight;
                                      });
                                    }
                                  },
                                  isSelected: selectedDepartureFlight == flight,
                                  scaffoldMessengerKey:
                                      widget.scaffoldMessengerKey,
                                );
                              },
                            ),
                          ),
                      if (widget.returnDate != null) ...[
                        const SizedBox(height: 16),
                        // Chuyến về
                        Text(
                          'Chuyến về: ${widget.arrivalCity} → ${widget.departureCity}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        state.returnFlights.isEmpty
                            ? Center(
                              child: Text(
                                'Không tìm thấy chuyến bay về.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                              ),
                            )
                            : Expanded(
                              child: ListView.builder(
                                itemCount: state.returnFlights.length,
                                itemBuilder: (context, index) {
                                  final flight = state.returnFlights[index];
                                  return FlightTicketCard(
                                    flight: flight,
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          selectedReturnFlight = flight;
                                        });
                                      }
                                    },
                                    isSelected: selectedReturnFlight == flight,
                                    scaffoldMessengerKey:
                                        widget.scaffoldMessengerKey,
                                  );
                                },
                              ),
                            ),
                      ],
                      const SizedBox(height: 16),
                      // Nút tiếp tục
                      if (selectedDepartureFlight != null &&
                          (widget.returnDate == null ||
                              selectedReturnFlight != null))
                        ElevatedButton(
                          onPressed: () {
                            widget.scaffoldMessengerKey.currentState
                                ?.hideCurrentSnackBar();
                            Navigator.pushNamed(
                              context,
                              AppRoutes.passengerInfo,
                              arguments: {
                                'flight': selectedDepartureFlight,
                                'returnFlight': selectedReturnFlight,
                                'passengerCount': widget.passengerCount,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Tiếp tục',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
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
      ),
    );
  }
}
