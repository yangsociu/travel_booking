// blocs/flight_search/flight_search_state.dart
// Các trạng thái tìm kiếm chuyến bay
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_search_model.dart';

class FlightSearchState extends Equatable {
  final String? departureCity;
  final String? arrivalCity;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengerCount;
  final bool isRoundTrip;
  final bool isLoading;
  final bool isSearchSuccess;
  final String? error;

  const FlightSearchState({
    this.departureCity,
    this.arrivalCity,
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
    String? arrivalCity,
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
      arrivalCity: arrivalCity ?? this.arrivalCity,
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
    );
  }

  @override
  List<Object?> get props => [
    departureCity,
    arrivalCity,
    departureDate,
    returnDate,
    passengerCount,
    isRoundTrip,
    isLoading,
    isSearchSuccess,
    error,
  ];
}
