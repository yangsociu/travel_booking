import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  const SeatSelectionScreen({
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
        body: BlocBuilder<SeatBloc, SeatState>(
          builder: (context, state) {
            if (state is SeatLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đang tải ghế...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SeatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi: ${state.message}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin chuyến đi
                  Text(
                    'Chuyến đi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFlightInfo(context, flight, selectedSeats),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Đã chọn: ${selectedSeats.length}/${passengers.length} ghế',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    Text(
                      'Chuyến về',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFlightInfo(
                      context,
                      returnFlight!,
                      returnSelectedSeats,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Đã chọn: ${returnSelectedSeats.length}/${passengers.length} ghế',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
  ) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${flight.departureCity} (${flight.departureAirportName})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  flight.departureAirportCode,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  departureTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.flight,
            size: 24,
            color: AppColors.primaryColor.withOpacity(0.7),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${flight.arrivalCity} (${flight.arrivalAirportName})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.flight_land,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  flight.arrivalAirportCode,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  arrivalTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
