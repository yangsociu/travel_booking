// admin_booking_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/services/ticket_service.dart';

part 'admin_booking_event.dart';
part 'admin_booking_state.dart';

class AdminBookingBloc extends Bloc<AdminBookingEvent, AdminBookingState> {
  final TicketService ticketService;

  AdminBookingBloc(this.ticketService) : super(AdminBookingLoading()) {
    on<LoadTickets>(_onLoadTickets);
    on<DeleteTicket>(_onDeleteTicket);
  }

  Future<void> _onLoadTickets(
    LoadTickets event,
    Emitter<AdminBookingState> emit,
  ) async {
    emit(AdminBookingLoading());
    try {
      final tickets = await ticketService.getAllTickets();
      emit(AdminBookingLoaded(tickets));
    } catch (e) {
      emit(AdminBookingError(e.toString()));
    }
  }

  Future<void> _onDeleteTicket(
    DeleteTicket event,
    Emitter<AdminBookingState> emit,
  ) async {
    try {
      await ticketService.deleteTicket(event.documentId);
      emit(AdminBookingLoaded(await ticketService.getAllTickets()));
    } catch (e) {
      emit(AdminBookingError(e.toString()));
    }
  }
}
