import 'package:equatable/equatable.dart';

abstract class SeatState extends Equatable {
  const SeatState();

  @override
  List<Object> get props => [];
}

class SeatLoading extends SeatState {}

class SeatLoaded extends SeatState {
  final Map<String, bool> seats;
  final List<String> selectedSeats; // Đảm bảo là List<String>

  SeatLoaded({required this.seats, required this.selectedSeats});

  @override
  List<Object> get props => [seats, selectedSeats ?? ''];
}

class SeatError extends SeatState {
  final String message;

  const SeatError({required this.message});

  @override
  List<Object> get props => [message];
}
