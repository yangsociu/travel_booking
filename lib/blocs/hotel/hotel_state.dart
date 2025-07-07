import 'package:booking_app/models/hotel_model.dart';
import 'package:equatable/equatable.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final List<HotelModel> hotels;

  const HotelLoaded(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class HotelBookingSuccess extends HotelState {}

class HotelBookingCancelSuccess extends HotelState {
  final String bookingId;

  const HotelBookingCancelSuccess(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);

  @override
  List<Object> get props => [message];
}

class UserBookingsLoaded extends HotelState {
  final List<HotelBooking> bookings;
  const UserBookingsLoaded(this.bookings);
  @override
  List<Object> get props => [bookings];
}

class AllHotelBookingsLoaded extends HotelState {
  final List<HotelBooking> bookings;

  AllHotelBookingsLoaded(this.bookings);
}
