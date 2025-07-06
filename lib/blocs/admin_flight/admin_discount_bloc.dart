import 'package:bloc/bloc.dart';
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
      print('Loading discounts from Firestore');
      final discounts = await flightService.getDiscounts();
      print('Loaded ${discounts.length} discounts');
      emit(AdminDiscountLoaded(discounts));
    } catch (e) {
      print('Error loading discounts: $e');
      emit(AdminDiscountError('Không thể tải danh sách mã giảm giá: $e'));
    }
  }

  Future<void> _onDeleteDiscount(
    DeleteDiscount event,
    Emitter<AdminDiscountState> emit,
  ) async {
    print('Starting _onDeleteDiscount with documentId: ${event.documentId}');
    emit(AdminDiscountLoading());
    try {
      print(
        'Calling flightService.deleteDiscount for documentId: ${event.documentId}',
      );
      await flightService.deleteDiscount(event.documentId);
      print('Discount deleted successfully: ${event.documentId}');
      if (state is AdminDiscountLoaded) {
        final updatedDiscounts =
            (state as AdminDiscountLoaded).discounts
                .where((d) => d.documentId != event.documentId)
                .toList();
        print('Updated discounts locally: ${updatedDiscounts.length} items');
        emit(AdminDiscountLoaded(updatedDiscounts));
      } else {
        print('State is not AdminDiscountLoaded, fetching discounts');
        final discounts = await flightService.getDiscounts();
        emit(AdminDiscountLoaded(discounts));
      }
    } catch (e) {
      print('Error in _onDeleteDiscount: $e');
      emit(AdminDiscountError('Không thể xóa mã giảm giá: $e'));
    } finally {
      print('Finished _onDeleteDiscount for documentId: ${event.documentId}');
    }
  }
}
