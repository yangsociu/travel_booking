// blocs/home/home_event.dart
// Các sự kiện trang Home
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
