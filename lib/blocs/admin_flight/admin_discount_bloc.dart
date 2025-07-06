import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (event.documentId.isEmpty) {
      print('Error: documentId is empty');
      emit(DeleteDiscountFailure('ID mã giảm giá không hợp lệ'));
      return;
    }
    emit(AdminDiscountLoading());
    try {
      print('Checking if document exists: ${event.documentId}');
      final doc =
          await FirebaseFirestore.instance
              .collection('discounts')
              .doc(event.documentId)
              .get();
      if (!doc.exists) {
        print('Error: Document ${event.documentId} does not exist');
        emit(DeleteDiscountFailure('Mã giảm giá không tồn tại'));
        return;
      }
      print(
        'Calling flightService.deleteDiscount for documentId: ${event.documentId}',
      );
      await flightService.deleteDiscount(event.documentId);
      print('Discount deleted successfully: ${event.documentId}');
      print('Emitting DeleteDiscountSuccess');
      emit(DeleteDiscountSuccess());
    } catch (e) {
      print('Error in _onDeleteDiscount: $e');
      emit(DeleteDiscountFailure('Không thể xóa mã giảm giá: $e'));
    } finally {
      print('Finished _onDeleteDiscount for documentId: ${event.documentId}');
    }
  }
}
