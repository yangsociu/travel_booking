// admin_flight_state.dart
// blocs/admin_flight/admin_flight_state.dart
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';

abstract class AdminFlightState extends Equatable {
  const AdminFlightState();

  @override
  List<Object> get props => [];
}

class AdminFlightInitial extends AdminFlightState {}

class AdminFlightLoading extends AdminFlightState {}

class AdminFlightLoaded extends AdminFlightState {
  final List<FlightModel> flights;

  const AdminFlightLoaded({required this.flights});

  @override
  List<Object> get props => [flights];
}

class AdminFlightError extends AdminFlightState {
  final String message;

  const AdminFlightError({required this.message});

  @override
  List<Object> get props => [message];
}
