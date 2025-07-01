// blocs/home/home_state.dart
// Các trạng thái trang Home
import 'package:equatable/equatable.dart';
import 'package:booking_app/models/airline_model.dart';
import 'package:booking_app/models/destination_model.dart';

class HomeState extends Equatable {
  final List<AirlineModel> airlines;
  final List<DestinationModel> destinations;
  final int selectedNavIconIndex;
  final int currentBottomNavIndex;
  final int selectedDestinationIndex;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.airlines = const [],
    this.destinations = const [],
    this.selectedNavIconIndex = 0,
    this.currentBottomNavIndex = 0,
    this.selectedDestinationIndex = 0,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<AirlineModel>? airlines,
    List<DestinationModel>? destinations,
    int? selectedNavIconIndex,
    int? currentBottomNavIndex,
    int? selectedDestinationIndex,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      airlines: airlines ?? this.airlines,
      destinations: destinations ?? this.destinations,
      selectedNavIconIndex: selectedNavIconIndex ?? this.selectedNavIconIndex,
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
      selectedDestinationIndex:
          selectedDestinationIndex ?? this.selectedDestinationIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    airlines,
    destinations,
    selectedNavIconIndex,
    currentBottomNavIndex,
    selectedDestinationIndex,
    isLoading,
    error,
  ];
}
