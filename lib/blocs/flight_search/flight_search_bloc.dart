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
    on<SwapCities>(_onSwapCities); // Explicitly ensure handler is registered
  }

  void _onToggleRoundTrip(
    ToggleRoundTrip event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(
      state.copyWith(
        isRoundTrip: event.isRoundTrip,
        returnDate:
            event.isRoundTrip
                ? state.returnDate
                : null, // Reset returnDate for one-way
      ),
    );
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
      emit(
        state.copyWith(
          departureCity: event.selectedCity['name'],
          departureAirportName: event.selectedCity['airportName'],
          departureAirportCode: event.selectedCity['airportCode'],
        ),
      );
    } else {
      emit(
        state.copyWith(
          arrivalCity: event.selectedCity['name'],
          arrivalAirportName: event.selectedCity['airportName'],
          arrivalAirportCode: event.selectedCity['airportCode'],
        ),
      );
    }
    print(
      'Handling ShowCityPicker event: ${event.isDeparture ? "Departure" : "Arrival"} city selected: ${event.selectedCity['name']}',
    ); // Debug log
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

  void _onSwapCities(SwapCities event, Emitter<FlightSearchState> emit) {
    print(
      'Handling SwapCities event: ${state.departureCity} <-> ${state.arrivalCity}',
    ); // Debug log
    emit(
      state.copyWith(
        departureCity: state.arrivalCity,
        arrivalCity: state.departureCity,
        departureAirportName: state.arrivalAirportName,
        departureAirportCode: state.arrivalAirportCode,
        arrivalAirportName: state.departureAirportName,
        arrivalAirportCode: state.departureAirportCode,
      ),
    );
  }
}
