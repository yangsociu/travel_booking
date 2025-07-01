import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';

class Ticket extends Equatable {
  final String id; // Document ID trong Firestore
  final FlightModel flight;
  final Passenger passenger;
  final String seat;
  final double ticketPrice;
  final DateTime bookingTime;

  const Ticket({
    required this.id,
    required this.flight,
    required this.passenger,
    required this.seat,
    required this.ticketPrice,
    required this.bookingTime,
  });

  factory Ticket.fromJson(Map<String, dynamic> json, String docId) {
    return Ticket(
      id: docId,
      flight: FlightModel.fromJson(
        json['flight'] as Map<String, dynamic>,
        json['flight']['documentId'] as String,
      ),
      passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>),
      seat: json['seat'] as String,
      ticketPrice: double.parse(json['ticketPrice'] as String),
      bookingTime: DateTime.parse(json['bookingTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight': flight.toJson(),
      'passenger': passenger.toJson(),
      'seat': seat,
      'ticketPrice': ticketPrice.toString(),
      'bookingTime': bookingTime.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [
    id,
    flight,
    passenger,
    seat,
    ticketPrice,
    bookingTime,
  ];
}
