import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/seat_selection/seat_event.dart';
import 'package:booking_app/blocs/seat_selection/seat_state.dart';
import 'package:booking_app/services/flight_service.dart';

class SeatBloc extends Bloc<SeatEvent, SeatState> {
  final FlightService flightService;

  SeatBloc({required this.flightService}) : super(SeatLoading()) {
    on<LoadSeats>(_onLoadSeats);
    on<SelectSeat>(_onSelectSeat);
  }

  Future<void> _onLoadSeats(LoadSeats event, Emitter<SeatState> emit) async {
    emit(SeatLoading());
    try {
      final seats = await flightService.getSeats(event.flightId);
      final returnSeats =
          event.returnFlightId != null
              ? await flightService.getSeats(event.returnFlightId!)
              : <String, bool>{};
      emit(
        SeatLoaded(
          seats: seats,
          selectedSeats: [],
          returnSeats: returnSeats,
          returnSelectedSeats: [],
        ),
      );
    } catch (e) {
      emit(SeatError(message: 'Lỗi khi tải danh sách ghế: $e'));
    }
  }

  void _onSelectSeat(SelectSeat event, Emitter<SeatState> emit) {
    if (state is SeatLoaded) {
      final currentState = state as SeatLoaded;
      final seats =
          event.isReturnFlight ? currentState.returnSeats : currentState.seats;
      final selectedSeats =
          event.isReturnFlight
              ? List<String>.from(currentState.returnSelectedSeats)
              : List<String>.from(currentState.selectedSeats);

      if (seats[event.seat] == true) {
        emit(SeatError(message: 'Ghế ${event.seat} đã được đặt'));
        return;
      }

      if (selectedSeats.contains(event.seat)) {
        selectedSeats.remove(event.seat);
      } else {
        selectedSeats.add(event.seat);
      }

      emit(
        SeatLoaded(
          seats: currentState.seats,
          selectedSeats:
              event.isReturnFlight ? currentState.selectedSeats : selectedSeats,
          returnSeats: currentState.returnSeats,
          returnSelectedSeats:
              event.isReturnFlight
                  ? selectedSeats
                  : currentState.returnSelectedSeats,
        ),
      );
    }
  }
}
