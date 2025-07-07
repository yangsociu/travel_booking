import 'package:booking_app/models/hotel_model.dart';
import 'package:equatable/equatable.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object> get props => [];
}

class LoadHotels extends HotelEvent {}

class BookHotel extends HotelEvent {
  final HotelBooking booking;

  const BookHotel(this.booking);

  @override
  List<Object> get props => [booking];
}

class CancelHotelBooking extends HotelEvent {
  final String bookingId;
  final String userId;

  const CancelHotelBooking(this.bookingId, this.userId);

  @override
  List<Object> get props => [bookingId, userId];
}

class LoadUserBookings extends HotelEvent {
  final String userId;
  const LoadUserBookings(this.userId);
  @override
  List<Object> get props => [userId];
}

class LoadAllHotelBookings extends HotelEvent {} // New event
