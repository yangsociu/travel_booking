// admin_booking_state.dart
part of 'admin_booking_bloc.dart';

abstract class AdminBookingState extends Equatable {
  const AdminBookingState();

  @override
  List<Object> get props => [];
}

class AdminBookingLoading extends AdminBookingState {}

class AdminBookingLoaded extends AdminBookingState {
  final List<Ticket> tickets;

  const AdminBookingLoaded(this.tickets);

  @override
  List<Object> get props => [tickets];
}

class AdminBookingError extends AdminBookingState {
  final String message;

  const AdminBookingError(this.message);

  @override
  List<Object> get props => [message];
}
