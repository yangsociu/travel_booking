import 'package:equatable/equatable.dart';

abstract class SeatEvent extends Equatable {
  const SeatEvent();

  @override
  List<Object> get props => [];
}

class LoadSeats extends SeatEvent {
  final String flightId;
  final String? returnFlightId;

  const LoadSeats({required this.flightId, this.returnFlightId});

  @override
  List<Object> get props => [flightId, returnFlightId ?? ''];
}

class SelectSeat extends SeatEvent {
  final String seat;
  final bool isReturnFlight;

  const SelectSeat(this.seat, {this.isReturnFlight = false});

  @override
  List<Object> get props => [seat, isReturnFlight];
}
