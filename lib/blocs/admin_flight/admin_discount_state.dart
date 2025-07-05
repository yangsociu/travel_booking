import 'package:booking_app/models/discount_model.dart';

abstract class AdminDiscountState {}

class AdminDiscountInitial extends AdminDiscountState {}

class AdminDiscountLoading extends AdminDiscountState {}

class AdminDiscountLoaded extends AdminDiscountState {
  final List<DiscountModel> discounts;

  AdminDiscountLoaded(this.discounts);
}

class AdminDiscountError extends AdminDiscountState {
  final String message;

  AdminDiscountError(this.message);
}
