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
      emit(SeatLoaded(seats: seats, selectedSeat: null));
    } catch (e) {
      emit(SeatError(message: 'Lỗi khi tải danh sách ghế: $e'));
    }
  }

  void _onSelectSeat(SelectSeat event, Emitter<SeatState> emit) {
    if (state is SeatLoaded) {
      final currentState = state as SeatLoaded;
      if (currentState.seats[event.seat] == true) {
        emit(SeatError(message: 'Ghế đã được đặt'));
        return;
      }
      final newSelectedSeat =
          currentState.selectedSeat == event.seat ? null : event.seat;
      emit(
        SeatLoaded(seats: currentState.seats, selectedSeat: newSelectedSeat),
      );
    }
  }
}
