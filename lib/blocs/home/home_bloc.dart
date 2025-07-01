// blocs/home/home_bloc.dart
// BLoC xử lý logic trang Home
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FlightService flightService;

  HomeBloc({required this.flightService}) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SelectNavIcon>(_onSelectNavIcon);
    on<SelectBottomNav>(_onSelectBottomNav);
    on<SelectDestination>(_onSelectDestination);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final airlines = await flightService.getAirlines();
      final destinations = await flightService.getDestinations();
      emit(
        state.copyWith(
          airlines: airlines,
          destinations: destinations,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSelectNavIcon(SelectNavIcon event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedNavIconIndex: event.index));
  }

  void _onSelectBottomNav(SelectBottomNav event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentBottomNavIndex: event.index));
  }

  void _onSelectDestination(SelectDestination event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedDestinationIndex: event.index));
  }
}
