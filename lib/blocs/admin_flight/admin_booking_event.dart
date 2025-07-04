// admin_booking_event.dart
part of 'admin_booking_bloc.dart';

abstract class AdminBookingEvent extends Equatable {
  const AdminBookingEvent();

  @override
  List<Object> get props => [];
}

class LoadTickets extends AdminBookingEvent {}

class DeleteTicket extends AdminBookingEvent {
  final String documentId;

  const DeleteTicket(this.documentId);

  @override
  List<Object> get props => [documentId];
}

class UpdateTicketStatus extends AdminBookingEvent {
  final String documentId;
  final bool isUsed;

  const UpdateTicketStatus(this.documentId, this.isUsed);

  @override
  List<Object> get props => [documentId, isUsed];
}
