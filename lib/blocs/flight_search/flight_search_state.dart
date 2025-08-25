// blocs/flight_search/flight_search_state.dart
// Các trạng thái tìm kiếm chuyến bay
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_search_model.dart';

class FlightSearchState extends Equatable {
  final String? departureCity;
  final String? departureAirportName; // Thêm trường tên sân bay điểm đi
  final String? departureAirportCode; // Thêm trường mã sân bay điểm đi
  final String? arrivalCity;
  final String? arrivalAirportName; // Thêm trường tên sân bay điểm đến
  final String? arrivalAirportCode; // Thêm trường mã sân bay điểm đến
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengerCount;
  final bool isRoundTrip;
  final bool isLoading;
  final bool isSearchSuccess;
  final String? error;

  const FlightSearchState({
    this.departureCity,
    this.departureAirportName,
    this.departureAirportCode,
    this.arrivalCity,
    this.arrivalAirportName,
    this.arrivalAirportCode,
    this.departureDate,
    this.returnDate,
    this.passengerCount = 1,
    this.isRoundTrip = false,
    this.isLoading = false,
    this.isSearchSuccess = false,
    this.error,
  });

  FlightSearchState copyWith({
    String? departureCity,
    String? departureAirportName,
    String? departureAirportCode,
    String? arrivalCity,
    String? arrivalAirportName,
    String? arrivalAirportCode,
    DateTime? departureDate,
    DateTime? returnDate,
    int? passengerCount,
    bool? isRoundTrip,
    bool? isLoading,
    bool? isSearchSuccess,
    String? error,
  }) {
    return FlightSearchState(
      departureCity: departureCity ?? this.departureCity,
      departureAirportName: departureAirportName ?? this.departureAirportName,
      departureAirportCode: departureAirportCode ?? this.departureAirportCode,
      arrivalCity: arrivalCity ?? this.arrivalCity,
      arrivalAirportName: arrivalAirportName ?? this.arrivalAirportName,
      arrivalAirportCode: arrivalAirportCode ?? this.arrivalAirportCode,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      passengerCount: passengerCount ?? this.passengerCount,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      isLoading: isLoading ?? this.isLoading,
      isSearchSuccess: isSearchSuccess ?? this.isSearchSuccess,
      error: error,
    );
  }

  bool get canSearch =>
      departureCity != null &&
      arrivalCity != null &&
      departureCity != arrivalCity &&
      departureDate != null &&
      (!isRoundTrip ||
          (isRoundTrip &&
              returnDate != null &&
              !returnDate!.isBefore(departureDate!)));

  FlightSearchModel toFlightSearchModel() {
    return FlightSearchModel(
      departureCity: departureCity,
      arrivalCity: arrivalCity,
      departureDate: departureDate,
      returnDate: returnDate,
      passengerCount: passengerCount,
      isRoundTrip: isRoundTrip,
      departureAirportCode: departureAirportCode, // Thêm mã sân bay
      arrivalAirportCode: arrivalAirportCode, // Thêm mã sân bay
    );
  }

  @override
  List<Object?> get props => [
    departureCity,
    departureAirportName,
    departureAirportCode,
    arrivalCity,
    arrivalAirportName,
    arrivalAirportCode,
    departureDate,
    returnDate,
    passengerCount,
    isRoundTrip,
    isLoading,
    isSearchSuccess,
    error,
  ];
}
