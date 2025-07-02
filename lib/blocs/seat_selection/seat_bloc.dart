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
      emit(SeatLoaded(seats: seats, selectedSeats: [])); // Khi load ghế
    } catch (e) {
      emit(SeatError(message: 'Lỗi khi tải danh sách ghế: $e'));
    }
  }

  void _onSelectSeat(SelectSeat event, Emitter<SeatState> emit) {
    if (state is SeatLoaded) {
      final currentState = state as SeatLoaded;
      if (currentState.seats[event.seat] == true) {
        emit(SeatError(message: 'Ghế ${event.seat} đã được đặt'));
        return;
      }
      final newSelectedSeats = List<String>.from(currentState.selectedSeats);
      if (newSelectedSeats.contains(event.seat)) {
        newSelectedSeats.remove(event.seat); // Bỏ chọn nếu ghế đã được chọn
      } else {
        newSelectedSeats.add(event.seat); // Thêm ghế vào danh sách
      }
      emit(
        SeatLoaded(seats: currentState.seats, selectedSeats: newSelectedSeats),
      ); // Khi chọn ghế
    }
  }
}
