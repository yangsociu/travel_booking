// payment_event.dart
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class StartPayment extends PaymentEvent {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;
  final String cardType;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final double discountPercentage;

  const StartPayment({
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
    required this.cardType,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.discountPercentage,
  });

  @override
  List<Object> get props => [
    flight,
    returnFlight ?? '', // Nếu null thì dùng chuỗi rỗng,
    passengers,
    selectedSeats,
    returnSelectedSeats,
    phoneNumber,
    email,
    cardType,
    cardNumber,
    cardHolder,
    expiryDate,
    cvv,
    discountPercentage,
  ];
}

class CancelPayment extends PaymentEvent {}
