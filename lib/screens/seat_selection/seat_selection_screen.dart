import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/seat_selection/seat_bloc.dart';
import 'package:booking_app/blocs/seat_selection/seat_event.dart';
import 'package:booking_app/blocs/seat_selection/seat_state.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/seat/seat_grid.dart';

class SeatSelectionScreen extends StatelessWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final String phoneNumber;
  final String email;

  SeatSelectionScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.phoneNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SeatBloc(flightService: context.read<FlightService>())..add(
                LoadSeats(
                  flightId: flight.documentId,
                  returnFlightId: returnFlight?.documentId,
                ),
              ),
      child: Scaffold(
        backgroundColor: AppColors.grey_2,
        appBar: AppBar(
          title: const Text(
            'Chọn chỗ ngồi',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SeatBloc, SeatState>(
          builder: (context, state) {
            if (state is SeatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SeatError) {
              return Center(child: Text(state.message));
            }
            final seats = state is SeatLoaded ? state.seats : <String, bool>{};
            final selectedSeats =
                state is SeatLoaded ? state.selectedSeats : <String>[];
            final returnSeats =
                state is SeatLoaded ? state.returnSeats : <String, bool>{};
            final returnSelectedSeats =
                state is SeatLoaded ? state.returnSelectedSeats : <String>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thông tin chuyến đi
                  _buildFlightInfo(context, flight, selectedSeats, 'Chuyến đi'),
                  const SizedBox(height: 8),
                  Text(
                    'Đã chọn: ${selectedSeats.length}/${passengers.length} ghế',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SeatGridWidget(
                    seats: seats,
                    selectedSeats: selectedSeats,
                    passengers: passengers,
                    isReturnFlight: false,
                    flight: flight,
                    onSeatSelected: (seat) {
                      if (selectedSeats.length < passengers.length ||
                          selectedSeats.contains(seat)) {
                        context.read<SeatBloc>().add(
                          SelectSeat(seat, isReturnFlight: false),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Bạn đã chọn đủ ${passengers.length} ghế',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  if (returnFlight != null) ...[
                    const SizedBox(height: 20),
                    _buildFlightInfo(
                      context,
                      returnFlight!,
                      returnSelectedSeats,
                      'Chuyến về',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đã chọn: ${returnSelectedSeats.length}/${passengers.length} ghế',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SeatGridWidget(
                      seats: returnSeats,
                      selectedSeats: returnSelectedSeats,
                      passengers: passengers,
                      isReturnFlight: true,
                      flight: returnFlight!,
                      onSeatSelected: (seat) {
                        if (returnSelectedSeats.length < passengers.length ||
                            returnSelectedSeats.contains(seat)) {
                          context.read<SeatBloc>().add(
                            SelectSeat(seat, isReturnFlight: true),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Bạn đã chọn đủ ${passengers.length} ghế',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed:
                            (selectedSeats.length == passengers.length &&
                                    (returnFlight == null ||
                                        returnSelectedSeats.length ==
                                            passengers.length))
                                ? () {
                                  final totalPrice =
                                      selectedSeats.fold<double>(0, (
                                        sum,
                                        seat,
                                      ) {
                                        return sum +
                                            (int.parse(seat[0]) <= 4
                                                ? flight.price * 1.5
                                                : flight.price);
                                      }) +
                                      (returnFlight != null
                                          ? returnSelectedSeats.fold<double>(
                                            0,
                                            (sum, seat) {
                                              return sum +
                                                  (int.parse(seat[0]) <= 4
                                                      ? returnFlight!.price *
                                                          1.5
                                                      : returnFlight!.price);
                                            },
                                          )
                                          : 0);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.payment,
                                    arguments: {
                                      'flight': flight,
                                      'returnFlight': returnFlight,
                                      'passengers': passengers,
                                      'selectedSeats': selectedSeats,
                                      'returnSelectedSeats':
                                          returnSelectedSeats,
                                      'phoneNumber': phoneNumber,
                                      'email': email,
                                      'ticketPrice': _formatPrice(totalPrice),
                                      'duration': _calculateDuration(
                                        flight.departureTime,
                                        flight.arrivalTime,
                                      ),
                                    },
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Xác nhận',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlightInfo(
    BuildContext context,
    FlightModel flight,
    List<String> selectedSeats,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: List.generate(passengers.length, (index) {
              return Text(
                passengers[index].fullName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${flight.departureCity} (${flight.departureCode}) -> ${flight.arrivalCity} (${flight.arrivalCode}) (${flight.id})',
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return '${(price / 1000).toStringAsFixed(0)}K';
  }

  String _calculateDuration(DateTime departure, DateTime arrival) {
    final duration = arrival.difference(departure);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
