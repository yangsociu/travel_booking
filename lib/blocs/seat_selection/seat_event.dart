import 'package:equatable/equatable.dart';

abstract class SeatEvent extends Equatable {
  const SeatEvent();

  @override
  List<Object> get props => [];
}

class LoadSeats extends SeatEvent {
  final String flightId;

  const LoadSeats({required this.flightId});

  @override
  List<Object> get props => [flightId];
}

class SelectSeat extends SeatEvent {
  final String seat;

  const SelectSeat(this.seat);

  @override
  List<Object> get props => [seat];
}
