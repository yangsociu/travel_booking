import 'package:equatable/equatable.dart';
import 'package:booking_app/models/discount_model.dart';

abstract class AdminDiscountState extends Equatable {
  const AdminDiscountState();

  @override
  List<Object?> get props => [];
}

class AdminDiscountInitial extends AdminDiscountState {}

class AdminDiscountLoading extends AdminDiscountState {}

class AdminDiscountLoaded extends AdminDiscountState {
  final List<DiscountModel> discounts;

  const AdminDiscountLoaded(this.discounts);

  @override
  List<Object?> get props => [discounts];
}

class AdminDiscountError extends AdminDiscountState {
  final String message;

  const AdminDiscountError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteDiscountSuccess extends AdminDiscountState {
  @override
  List<Object?> get props => [];
}

class DeleteDiscountFailure extends AdminDiscountState {
  final String message;

  const DeleteDiscountFailure(this.message);

  @override
  List<Object?> get props => [message];
}
