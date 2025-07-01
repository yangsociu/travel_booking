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
  final Passenger passenger;
  final String seat;
  final double ticketPrice;
  final String cardType;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;

  const StartPayment({
    required this.flight,
    required this.passenger,
    required this.seat,
    required this.ticketPrice,
    required this.cardType,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  List<Object> get props => [
    flight,
    passenger,
    seat,
    ticketPrice,
    cardType,
    cardNumber,
    cardHolder,
    expiryDate,
    cvv,
  ];
}

class CancelPayment extends PaymentEvent {}
