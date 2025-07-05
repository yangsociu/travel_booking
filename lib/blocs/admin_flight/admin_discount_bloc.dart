import 'package:bloc/bloc.dart';
import 'package:booking_app/models/discount_model.dart';
import 'package:booking_app/services/flight_service.dart';
import 'admin_discount_event.dart';
import 'admin_discount_state.dart';

class AdminDiscountBloc extends Bloc<AdminDiscountEvent, AdminDiscountState> {
  final FlightService flightService;

  AdminDiscountBloc(this.flightService) : super(AdminDiscountInitial()) {
    on<LoadDiscounts>(_onLoadDiscounts);
    on<DeleteDiscount>(_onDeleteDiscount);
  }

  Future<void> _onLoadDiscounts(
    LoadDiscounts event,
    Emitter<AdminDiscountState> emit,
  ) async {
    emit(AdminDiscountLoading());
    try {
      final discounts = await flightService.getDiscounts();
      emit(AdminDiscountLoaded(discounts));
    } catch (e) {
      emit(AdminDiscountError('Không thể tải danh sách mã giảm giá: $e'));
    }
  }

  Future<void> _onDeleteDiscount(
    DeleteDiscount event,
    Emitter<AdminDiscountState> emit,
  ) async {
    try {
      await flightService.deleteDiscount(event.documentId);
      final discounts = await flightService.getDiscounts();
      emit(AdminDiscountLoaded(discounts));
    } catch (e) {
      emit(AdminDiscountError('Không thể xóa mã giảm giá: $e'));
    }
  }
}
