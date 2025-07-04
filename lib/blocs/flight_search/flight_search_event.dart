// blocs/flight_search/flight_search_event.dart
// Các sự kiện tìm kiếm chuyến bay
import 'package:equatable/equatable.dart';

abstract class FlightSearchEvent extends Equatable {
  const FlightSearchEvent();

  @override
  List<Object> get props => [];
}

class ToggleRoundTrip extends FlightSearchEvent {
  final bool isRoundTrip;

  const ToggleRoundTrip(this.isRoundTrip);

  @override
  List<Object> get props => [isRoundTrip];
}

class SelectDate extends FlightSearchEvent {
  final bool isDeparture;
  final DateTime pickedDate;

  const SelectDate({required this.isDeparture, required this.pickedDate});

  @override
  List<Object> get props => [isDeparture, pickedDate];
}

class ShowCityPicker extends FlightSearchEvent {
  final bool isDeparture;
  final Map<String, String> selectedCity;

  const ShowCityPicker({required this.isDeparture, required this.selectedCity});

  @override
  List<Object> get props => [isDeparture, selectedCity];
}

class ShowPassengerPicker extends FlightSearchEvent {
  final int newCount;

  const ShowPassengerPicker({required this.newCount});

  @override
  List<Object> get props => [newCount];
}

class SearchFlights extends FlightSearchEvent {}

// Thêm sự kiện mới để hoán đổi điểm đi và điểm đến
class SwapCities extends FlightSearchEvent {
  const SwapCities();

  @override
  List<Object> get props => []; // Corrected to return List<Object>
}
