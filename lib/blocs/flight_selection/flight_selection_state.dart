// flight_state.dart
// blocs/flight_selection/flight_selection_state.dart
// Các trạng thái chọn chuyến bay
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';

abstract class FlightSelectionState extends Equatable {
  const FlightSelectionState();

  @override
  List<Object> get props => [];
}

class FlightSelectionInitial extends FlightSelectionState {}

class FlightSelectionLoading extends FlightSelectionState {}

class FlightSelectionLoaded extends FlightSelectionState {
  final List<FlightModel> departureFlights;
  final List<FlightModel> returnFlights;

  const FlightSelectionLoaded({
    required this.departureFlights,
    required this.returnFlights,
  });

  @override
  List<Object> get props => [departureFlights, returnFlights];
}

class FlightSelectionError extends FlightSelectionState {
  final String message;

  const FlightSelectionError({required this.message});

  @override
  List<Object> get props => [message];
}
