// blocs/flight_search/flight_search_bloc.dart
// BLoC xử lý logic tìm kiếm chuyến bay
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/blocs/flight_search/flight_search_event.dart';
import 'package:booking_app/blocs/flight_search/flight_search_state.dart';

class FlightSearchBloc extends Bloc<FlightSearchEvent, FlightSearchState> {
  final FlightService flightService;

  FlightSearchBloc({required this.flightService})
    : super(const FlightSearchState()) {
    on<ToggleRoundTrip>(_onToggleRoundTrip);
    on<SelectDate>(_onSelectDate);
    on<ShowCityPicker>(_onShowCityPicker);
    on<ShowPassengerPicker>(_onShowPassengerPicker);
    on<SearchFlights>(_onSearchFlights);
  }

  void _onToggleRoundTrip(
    ToggleRoundTrip event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(isRoundTrip: event.isRoundTrip));
  }

  void _onSelectDate(SelectDate event, Emitter<FlightSearchState> emit) {
    if (event.isDeparture) {
      emit(state.copyWith(departureDate: event.pickedDate));
    } else {
      emit(state.copyWith(returnDate: event.pickedDate));
    }
  }

  void _onShowCityPicker(
    ShowCityPicker event,
    Emitter<FlightSearchState> emit,
  ) {
    if (event.isDeparture) {
      emit(state.copyWith(departureCity: event.selectedCity));
    } else {
      emit(state.copyWith(arrivalCity: event.selectedCity));
    }
  }

  void _onShowPassengerPicker(
    ShowPassengerPicker event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(passengerCount: event.newCount));
  }

  Future<void> _onSearchFlights(
    SearchFlights event,
    Emitter<FlightSearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await flightService.searchFlights(state.toFlightSearchModel());
      emit(state.copyWith(isLoading: false, isSearchSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
