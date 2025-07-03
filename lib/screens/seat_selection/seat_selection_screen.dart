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
import 'package:intl/intl.dart';

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
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.grey_2,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
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
                  // Chuyến đi
                  _buildFlightInfo(context, flight, selectedSeats, 'Chuyến đi'),
                  const SizedBox(height: 20),
                  Text(
                    'Đã chọn: ${selectedSeats.length}/${passengers.length} ghế (Chuyến đi)',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSeatGrid(context, seats, selectedSeats, false),
                  if (returnFlight != null) ...[
                    const SizedBox(height: 20),
                    _buildFlightInfo(
                      context,
                      returnFlight!,
                      returnSelectedSeats,
                      'Chuyến về',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Đã chọn: ${returnSelectedSeats.length}/${passengers.length} ghế (Chuyến về)',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSeatGrid(
                      context,
                      returnSeats,
                      returnSelectedSeats,
                      true,
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        (selectedSeats.length == passengers.length &&
                                (returnFlight == null ||
                                    returnSelectedSeats.length ==
                                        passengers.length))
                            ? () {
                              final totalPrice =
                                  selectedSeats.fold<double>(0, (sum, seat) {
                                    return sum +
                                        (int.parse(seat[0]) <= 4
                                            ? flight.price * 1.5
                                            : flight.price);
                                  }) +
                                  (returnFlight != null
                                      ? returnSelectedSeats.fold<double>(0, (
                                        sum,
                                        seat,
                                      ) {
                                        return sum +
                                            (int.parse(seat[0]) <= 4
                                                ? returnFlight!.price * 1.5
                                                : returnFlight!.price);
                                      })
                                      : 0);
                              print(
                                'Navigating to payment with ${passengers.length} passengers, seats: $selectedSeats, returnSeats: $returnSelectedSeats',
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.payment,
                                arguments: {
                                  'flight': flight,
                                  'returnFlight': returnFlight,
                                  'passengers': passengers,
                                  'selectedSeats': selectedSeats,
                                  'returnSelectedSeats': returnSelectedSeats,
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
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.departureCode,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/flight_selection_screen/ph_dot-duotone.png',
                      width: 28,
                      height: 28,
                      color: AppColors.white,
                    ),
                    Container(height: 2, width: 80, color: AppColors.white),
                    Image.asset(
                      'assets/icons/flight_selection_screen/weui_location-outlined.png',
                      width: 16,
                      height: 16,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              Text(
                flight.arrivalCode,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('HH:mm dd MMM yyyy').format(flight.departureTime),
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.white, thickness: 1),
          const SizedBox(height: 8),
          Text(
            '${passengers.length} hành khách',
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

  Widget _buildSeatGrid(
    BuildContext context,
    Map<String, bool> seats,
    List<String> selectedSeats,
    bool isReturnFlight,
  ) {
    return Container(
      width: 324,
      height: _calculateTotalHeight(),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.grey_2,
        image: const DecorationImage(
          image: AssetImage('assets/images/tauuu.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Hạng thương gia',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _formatPrice(
              (isReturnFlight ? returnFlight?.price : flight.price)! * 1.5,
            ),
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          for (var row in _businessSeats)
            _buildSeatRow(context, row, seats, selectedSeats, isReturnFlight),
          const SizedBox(height: 20),
          const Text(
            'Hạng phổ thông',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _formatPrice(
              (isReturnFlight ? returnFlight?.price : flight.price)!,
            ),
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          for (var row in _economySeats)
            _buildSeatRow(context, row, seats, selectedSeats, isReturnFlight),
        ],
      ),
    );
  }

  final List<List<String>> _businessSeats = [
    ['1A', '1B', '1C', '1D'],
    ['2A', '2B', '2C', '2D'],
    ['3A', '3B', '3C', '3D'],
    ['4A', '4B', '4C', '4D'],
  ];
  final List<List<String>> _economySeats = [
    ['5A', '5B', '5C', '5D'],
    ['6A', '6B', '6C', '6D'],
    ['7A', '7B', '7C', '7D'],
    ['8A', '8B', '8C', '8D'],
    ['9A', '9B', '9C', '9D'],
  ];

  double _calculateTotalHeight() {
    const double seatHeight = 40;
    const double seatPadding = 4;
    const double sectionSpacing = 20;
    const double titleHeight = 16;
    const double priceHeight = 20;
    const double titleSpacing = 4;
    const double seatSectionSpacing = 12;
    const double topPadding = 32;
    const double containerPadding = 16;
    const double bufferHeight = 32;
    final double businessHeight =
        _businessSeats.length * (seatHeight + seatPadding * 2) +
        titleHeight +
        priceHeight +
        titleSpacing +
        seatSectionSpacing;
    final double economyHeight =
        _economySeats.length * (seatHeight + seatPadding * 2) +
        titleHeight +
        priceHeight +
        titleSpacing +
        seatSectionSpacing;
    return businessHeight +
        economyHeight +
        sectionSpacing +
        topPadding +
        containerPadding * 2 +
        bufferHeight;
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

  Widget _buildSeatRow(
    BuildContext context,
    List<String> row,
    Map<String, bool> seats,
    List<String> selectedSeats,
    bool isReturnFlight,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            row.map((seat) {
              final isBooked = seats[seat] ?? false;
              final isSelected = selectedSeats.contains(seat);
              return GestureDetector(
                onTap:
                    isBooked
                        ? null
                        : () {
                          if (selectedSeats.length < passengers.length ||
                              isSelected) {
                            context.read<SeatBloc>().add(
                              SelectSeat(seat, isReturnFlight: isReturnFlight),
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
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isBooked
                            ? AppColors.grey
                            : (isSelected ? AppColors.white : AppColors.grey_2),
                    border:
                        isSelected
                            ? Border.all(color: AppColors.grey_2, width: 2)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      seat[1],
                      style: TextStyle(
                        color:
                            isBooked
                                ? AppColors.white
                                : (isSelected
                                    ? AppColors.black
                                    : AppColors.black.withOpacity(0.7)),
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
