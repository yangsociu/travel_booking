import 'package:booking_app/models/passenger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/payment/payment_event.dart';
import 'package:booking_app/blocs/payment/payment_state.dart';
import 'package:booking_app/services/flight_service.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final FlightService flightService;

  PaymentBloc({required this.flightService}) : super(PaymentInitial()) {
    on<StartPayment>(_onStartPayment);
    on<CancelPayment>(_onCancelPayment);
  }

  Future<void> _onStartPayment(
    StartPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      // Validation thẻ (giả lập)
      if (!_validateCardDetails(
        event.cardType,
        event.cardNumber,
        event.cardHolder,
        event.expiryDate,
        event.cvv,
      )) {
        emit(const PaymentError(message: 'Thông tin thẻ không hợp lệ'));
        return;
      }

      // Đặt ghế cho chuyến đi
      for (var seat in event.selectedSeats) {
        await flightService.bookSeat(event.flight.documentId, seat);
        print('Booked seat: $seat for flight ${event.flight.documentId}');
      }

      // Lưu vé cho chuyến đi
      for (int i = 0; i < event.passengers.length; i++) {
        final passenger = event.passengers[i];
        final seat = event.selectedSeats[i];
        final seatNumber = int.tryParse(seat[0]) ?? 5;
        final basePrice =
            seatNumber <= 4 ? event.flight.price * 1.5 : event.flight.price;
        final ticketPrice = basePrice * (1 - event.discountPercentage / 100);
        await flightService.bookTicket(
          flight: event.flight,
          passenger: Passenger(
            fullName: passenger.fullName,
            birthYear: passenger.birthYear,
            gender: passenger.gender,
            phoneNumber: event.phoneNumber,
            email: event.email,
          ),
          seat: seat,
          ticketPrice: ticketPrice,
          phoneNumber: event.phoneNumber,
          email: event.email,
          discountPercentage: event.discountPercentage,
        );
        print(
          'Booked ticket for passenger ${passenger.fullName}, seat: $seat, price: $ticketPrice, discount: ${event.discountPercentage}%',
        );
      }

      // Đặt ghế và lưu vé cho chuyến về (nếu có)
      if (event.returnFlight != null) {
        for (var seat in event.returnSelectedSeats) {
          await flightService.bookSeat(event.returnFlight!.documentId, seat);
          print(
            'Booked seat: $seat for return flight ${event.returnFlight!.documentId}',
          );
        }
        for (int i = 0; i < event.passengers.length; i++) {
          final passenger = event.passengers[i];
          final seat = event.returnSelectedSeats[i];
          final seatNumber = int.tryParse(seat[0]) ?? 5;
          final basePrice =
              seatNumber <= 4
                  ? event.returnFlight!.price * 1.5
                  : event.returnFlight!.price;
          final ticketPrice = basePrice * (1 - event.discountPercentage / 100);
          await flightService.bookTicket(
            flight: event.returnFlight!,
            passenger: Passenger(
              fullName: passenger.fullName,
              birthYear: passenger.birthYear,
              gender: passenger.gender,
              phoneNumber: event.phoneNumber,
              email: event.email,
            ),
            seat: seat,
            ticketPrice: ticketPrice,
            phoneNumber: event.phoneNumber,
            email: event.email,
            discountPercentage: event.discountPercentage,
          );
          print(
            'Booked ticket for passenger ${passenger.fullName}, seat: $seat, price: $ticketPrice, discount: ${event.discountPercentage}%',
          );
        }
      }

      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(message: 'Lỗi khi xử lý thanh toán: $e'));
    }
  }

  void _onCancelPayment(CancelPayment event, Emitter<PaymentState> emit) {
    emit(PaymentInitial());
  }

  bool _validateCardDetails(
    String cardType,
    String cardNumber,
    String cardHolder,
    String expiryDate,
    String cvv,
  ) {
    // Validation giả lập
    if (!RegExp(r'^\d{4}\s?\d{4}\s?\d{4}\s?\d{4}$').hasMatch(cardNumber)) {
      return false;
    }
    if (cardHolder.isEmpty) {
      return false;
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiryDate)) {
      return false;
    }
    if (!RegExp(r'^\d{3,4}$').hasMatch(cvv)) {
      return false;
    }
    return true;
  }
}
