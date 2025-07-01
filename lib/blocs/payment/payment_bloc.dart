// payment_bloc.dart
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

      // Đặt ghế
      await flightService.bookSeat(event.flight.documentId, event.seat);

      // Lưu vé
      await flightService.bookTicket(
        flight: event.flight,
        passenger: event.passenger,
        seat: event.seat,
        ticketPrice: event.ticketPrice,
      );

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
