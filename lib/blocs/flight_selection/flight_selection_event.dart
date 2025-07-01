// flight_event.dart
// blocs/flight_selection/flight_selection_event.dart
// Các sự kiện chọn chuyến bay
import 'package:equatable/equatable.dart';

abstract class FlightSelectionEvent extends Equatable {
  const FlightSelectionEvent();

  @override
  List<Object> get props => [];
}

class LoadFlights extends FlightSelectionEvent {
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;

  const LoadFlights({
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
  });

  @override
  List<Object> get props => [departureCity, arrivalCity, departureDate];
}
