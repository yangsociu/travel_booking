import 'package:equatable/equatable.dart';

abstract class SeatState extends Equatable {
  const SeatState();

  @override
  List<Object> get props => [];
}

class SeatLoading extends SeatState {}

class SeatLoaded extends SeatState {
  final Map<String, bool> seats;
  final String? selectedSeat;

  const SeatLoaded({required this.seats, this.selectedSeat});

  @override
  List<Object> get props => [seats, selectedSeat ?? ''];
}

class SeatError extends SeatState {
  final String message;

  const SeatError({required this.message});

  @override
  List<Object> get props => [message];
}
