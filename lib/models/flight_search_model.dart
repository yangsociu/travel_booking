// models/flight_search_model.dart
// Model cho dữ liệu tìm kiếm chuyến bay
import 'package:equatable/equatable.dart';

class FlightSearchModel extends Equatable {
  final String? departureCity;
  final String? arrivalCity;
  final String? departureAirportCode;
  final String? arrivalAirportCode;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengerCount;
  final bool isRoundTrip;

  const FlightSearchModel({
    this.departureCity,
    this.arrivalCity,
    this.departureAirportCode,
    this.arrivalAirportCode,
    this.departureDate,
    this.returnDate,
    this.passengerCount = 1,
    this.isRoundTrip = false,
  });

  @override
  List<Object?> get props => [
    departureCity,
    arrivalCity,
    departureAirportCode,
    arrivalAirportCode,
    departureDate,
    returnDate,
    passengerCount,
    isRoundTrip,
  ];
}
