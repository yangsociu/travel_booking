import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class SelectNavIcon extends HomeEvent {
  final int index;

  const SelectNavIcon(this.index);

  @override
  List<Object> get props => [index];
}

class SelectBottomNav extends HomeEvent {
  final int index;

  const SelectBottomNav(this.index);

  @override
  List<Object> get props => [index];
}

class SelectDestination extends HomeEvent {
  final int index;

  const SelectDestination(this.index);

  @override
  List<Object> get props => [index];
}

class SelectDiscount extends HomeEvent {
  final String code;

  const SelectDiscount(this.code);

  @override
  List<Object> get props => [code];
}

class LoadDiscounts extends HomeEvent {}

class CheckDiscountClaimed extends HomeEvent {
  final String userId;

  const CheckDiscountClaimed(this.userId);

  @override
  List<Object> get props => [userId];
}
