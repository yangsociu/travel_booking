// flight_bloc.dart
// blocs/flight_selection/flight_selection_bloc.dart
// BLoC xử lý logic chọn chuyến bay
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_event.dart';
import 'package:booking_app/blocs/flight_selection/flight_selection_state.dart';

class FlightSelectionBloc
    extends Bloc<FlightSelectionEvent, FlightSelectionState> {
  final FlightService flightService;

  FlightSelectionBloc({required this.flightService})
    : super(FlightSelectionInitial()) {
    on<LoadFlights>(_onLoadFlights);
  }

  Future<void> _onLoadFlights(
    LoadFlights event,
    Emitter<FlightSelectionState> emit,
  ) async {
    emit(FlightSelectionLoading());
    try {
      final flights = await flightService.getFlights(
        departureCity: event.departureCity,
        arrivalCity: event.arrivalCity,
        departureDate: event.departureDate,
      );
      emit(FlightSelectionLoaded(flights: flights));
    } catch (e) {
      emit(FlightSelectionError(message: e.toString()));
    }
  }
}
