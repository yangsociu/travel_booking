// admin_flight_event.dart
// blocs/admin_flight/admin_flight_event.dart
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';

abstract class AdminFlightEvent extends Equatable {
  const AdminFlightEvent();

  @override
  List<Object> get props => [];
}

class LoadFlights extends AdminFlightEvent {}

class AddFlight extends AdminFlightEvent {
  final FlightModel flight;

  const AddFlight(this.flight);

  @override
  List<Object> get props => [flight];
}

class UpdateFlight extends AdminFlightEvent {
  final FlightModel flight;

  const UpdateFlight(this.flight);

  @override
  List<Object> get props => [flight];
}

class DeleteFlight extends AdminFlightEvent {
  final String flightId;

  const DeleteFlight(this.flightId);

  @override
  List<Object> get props => [flightId];
}
