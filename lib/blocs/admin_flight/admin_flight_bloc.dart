import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/services/flight_service.dart';
import 'admin_flight_event.dart';
import 'admin_flight_state.dart';

class AdminFlightBloc extends Bloc<AdminFlightEvent, AdminFlightState> {
  final FlightService flightService;

  AdminFlightBloc(this.flightService) : super(AdminFlightInitial()) {
    on<LoadFlights>(_onLoadFlights);
    on<AddFlight>(_onAddFlight);
    on<UpdateFlight>(_onUpdateFlight);
    on<DeleteFlight>(_onDeleteFlight);
  }

  Future<void> _onLoadFlights(
    LoadFlights event,
    Emitter<AdminFlightState> emit,
  ) async {
    emit(AdminFlightLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('flights').get();
      final flights =
          snapshot.docs
              .map((doc) => FlightModel.fromJson(doc.data(), doc.id))
              .toList();
      print('Admin flights fetched: ${flights.length}');
      emit(AdminFlightLoaded(flights: flights));
    } catch (e) {
      print('Error loading flights: $e');
      emit(AdminFlightError(message: 'Không thể tải danh sách chuyến bay: $e'));
    }
  }

  Future<void> _onAddFlight(
    AddFlight event,
    Emitter<AdminFlightState> emit,
  ) async {
    try {
      await flightService.addFlight(event.flight);
      final currentFlights =
          state is AdminFlightLoaded
              ? (state as AdminFlightLoaded).flights
              : <FlightModel>[];
      emit(AdminFlightLoaded(flights: [...currentFlights, event.flight]));
    } catch (e) {
      print('Error adding flight: $e');
      emit(AdminFlightError(message: e.toString()));
    }
  }

  Future<void> _onUpdateFlight(
    UpdateFlight event,
    Emitter<AdminFlightState> emit,
  ) async {
    try {
      await flightService.updateFlight(event.flight);
      if (state is AdminFlightLoaded) {
        final updatedFlights =
            (state as AdminFlightLoaded).flights
                .map((f) => f.id == event.flight.id ? event.flight : f)
                .toList();
        emit(AdminFlightLoaded(flights: updatedFlights));
      } else {
        emit(
          AdminFlightError(
            message: 'Không thể cập nhật: Danh sách chuyến bay chưa được tải.',
          ),
        );
      }
    } catch (e) {
      print('Error updating flight: $e');
      emit(AdminFlightError(message: e.toString()));
    }
  }

  Future<void> _onDeleteFlight(
    DeleteFlight event,
    Emitter<AdminFlightState> emit,
  ) async {
    try {
      await flightService.deleteFlight(event.flightId);
      if (state is AdminFlightLoaded) {
        final updatedFlights =
            (state as AdminFlightLoaded).flights
                .where((f) => f.documentId != event.flightId)
                .toList();
        emit(AdminFlightLoaded(flights: updatedFlights));
      } else {
        emit(
          AdminFlightError(
            message: 'Không thể xóa: Danh sách chuyến bay chưa được tải.',
          ),
        );
      }
    } catch (e) {
      print('Error deleting flight: $e');
      emit(AdminFlightError(message: e.toString()));
    }
  }
}
