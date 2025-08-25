import 'package:equatable/equatable.dart';
import 'package:booking_app/models/airline_model.dart';
import 'package:booking_app/models/destination_model.dart';
import 'package:booking_app/models/discount_model.dart';

class HomeState extends Equatable {
  final List<AirlineModel> airlines;
  final List<DestinationModel> destinations;
  final List<DiscountModel> discounts;
  final String? selectedDiscountCode;
  final List<String> claimedDiscountCodes;
  final int selectedNavIconIndex;
  final int currentBottomNavIndex;
  final int selectedDestinationIndex;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.airlines = const [],
    this.destinations = const [],
    this.discounts = const [],
    this.selectedDiscountCode,
    this.claimedDiscountCodes = const [],
    this.selectedNavIconIndex = 0,
    this.currentBottomNavIndex = 0,
    this.selectedDestinationIndex = 0,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<AirlineModel>? airlines,
    List<DestinationModel>? destinations,
    List<DiscountModel>? discounts,
    String? selectedDiscountCode,
    List<String>? claimedDiscountCodes,
    int? selectedNavIconIndex,
    int? currentBottomNavIndex,
    int? selectedDestinationIndex,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      airlines: airlines ?? this.airlines,
      destinations: destinations ?? this.destinations,
      discounts: discounts ?? this.discounts,
      selectedDiscountCode: selectedDiscountCode ?? this.selectedDiscountCode,
      claimedDiscountCodes: claimedDiscountCodes ?? this.claimedDiscountCodes,
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
    discounts,
    selectedDiscountCode,
    claimedDiscountCodes,
    selectedNavIconIndex,
    currentBottomNavIndex,
    selectedDestinationIndex,
    isLoading,
    error,
  ];
}
