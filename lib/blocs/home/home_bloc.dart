import 'package:cloud_firestore/cloud_firestore.dart';
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
    on<SelectDiscount>(_onSelectDiscount);
    on<CheckDiscountClaimed>(_onCheckDiscountClaimed);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final destinations = await flightService.getDestinations();
      final discounts = await flightService.getDiscounts();
      emit(
        state.copyWith(
          destinations: destinations,
          discounts: discounts,
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

  Future<void> _onSelectDiscount(
    SelectDiscount event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedDiscountCode: event.code));
  }

  Future<void> _onCheckDiscountClaimed(
    CheckDiscountClaimed event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('used_discounts')
              .where('userId', isEqualTo: event.userId)
              .get();
      final claimedCodes =
          snapshot.docs.map((doc) => doc['discountCode'] as String).toList();
      emit(state.copyWith(claimedDiscountCodes: claimedCodes));
    } catch (e) {
      emit(state.copyWith(error: 'Lỗi khi kiểm tra mã giảm giá: $e'));
    }
  }
}
