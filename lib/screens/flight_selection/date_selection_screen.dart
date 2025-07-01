// screens/flight_selection/date_selection_screen.dart
// Màn hình chọn ngày và thông tin tìm kiếm
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/flight_search/flight_search_bloc.dart';
import 'package:booking_app/blocs/flight_search/flight_search_event.dart';
import 'package:booking_app/blocs/flight_search/flight_search_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/flight_selection/city_selector.dart';
import 'package:booking_app/widgets/flight_selection/date_selector.dart';
import 'package:booking_app/widgets/flight_selection/passenger_picker.dart';
import 'package:booking_app/widgets/flight_selection/round_trip_switch.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/utils/app_theme.dart';
import 'package:booking_app/routes/app_routes.dart';

class DateSelectionScreen extends StatelessWidget {
  const DateSelectionScreen({super.key});

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      context.read<FlightSearchBloc>().add(
        SelectDate(isDeparture: isDeparture, pickedDate: picked),
      );
    }
  }

  Future<void> _showCityPicker(BuildContext context, bool isDeparture) async {
    final cities =
        await context.read<FlightSearchBloc>().flightService.getCities();
    print('Cities fetched for picker: $cities'); // Debug log
    if (context.mounted) {
      if (cities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Không có thành phố nào để hiển thị. Vui lòng kiểm tra dữ liệu Firestore.',
            ),
          ),
        );
        return;
      }
      final String? selectedCity = await showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Chọn thành phố',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          cities[index],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 16, color: AppColors.black),
                        ),
                        onTap: () => Navigator.pop(context, cities[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (selectedCity != null && context.mounted) {
        print(
          'Selected city: $selectedCity, isDeparture: $isDeparture',
        ); // Debug log
        context.read<FlightSearchBloc>().add(
          ShowCityPicker(isDeparture: isDeparture, selectedCity: selectedCity),
        );
      }
    }
  }

  Future<void> _showPassengerPicker(BuildContext context) async {
    int tempCount = context.read<FlightSearchBloc>().state.passengerCount;
    final int? newCount = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 200,
              child: Column(
                children: [
                  Text(
                    'Số lượng khách',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: AppColors.black),
                        onPressed: () {
                          if (tempCount > 1) {
                            setState(() {
                              tempCount--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$tempCount',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          color: AppColors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: AppColors.black),
                        onPressed: () {
                          setState(() {
                            tempCount++;
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, tempCount),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Xác nhận',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (newCount != null && context.mounted) {
      context.read<FlightSearchBloc>().add(
        ShowPassengerPicker(newCount: newCount),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlightSearchBloc(flightService: FlightService()),
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: AppBar(
          title: Text(
            'Chọn ngày',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.grey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Điểm đi
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return CitySelector(
                            label: 'Chọn điểm đi',
                            iconPath:
                                'assets/icons/date_selection_screen/tdesign_location-filled.png',
                            selectedCity: state.departureCity,
                            onTap: () => _showCityPicker(context, true),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Điểm đến
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return CitySelector(
                            label: 'Chọn điểm đến',
                            iconPath:
                                'assets/icons/date_selection_screen/tdesign_location-filled.png',
                            selectedCity: state.arrivalCity,
                            onTap: () => _showCityPicker(context, false),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Ngày đi
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return DateSelector(
                            label: 'Ngày đi',
                            selectedDate: state.departureDate,
                            onTap: () => _selectDate(context, true),
                          );
                        },
                      ),
                      // Ngày về (nếu khứ hồi)
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          if (state.isRoundTrip) {
                            return Column(
                              children: [
                                const SizedBox(height: 12),
                                DateSelector(
                                  label: 'Ngày về',
                                  selectedDate: state.returnDate,
                                  onTap: () => _selectDate(context, false),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 12),
                      // Số khách
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return PassengerPicker(
                            passengerCount: state.passengerCount,
                            onTap: () => _showPassengerPicker(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Công tắc khứ hồi
                BlocBuilder<FlightSearchBloc, FlightSearchState>(
                  builder: (context, state) {
                    return RoundTripSwitch(
                      isRoundTrip: state.isRoundTrip,
                      onChanged: (value) {
                        context.read<FlightSearchBloc>().add(
                          ToggleRoundTrip(value),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<FlightSearchBloc, FlightSearchState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state.canSearch
                              ? () {
                                context.read<FlightSearchBloc>().add(
                                  SearchFlights(),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Tìm chuyến bay',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  },
                ),
                // Thông báo lỗi
                BlocListener<FlightSearchBloc, FlightSearchState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error!)));
                    } else if (state.isSearchSuccess) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.flightSelection,
                        arguments: {
                          'departureCity': state.departureCity,
                          'arrivalCity': state.arrivalCity,
                          'departureDate': state.departureDate,
                          'returnDate': state.returnDate,
                          'passengerCount': state.passengerCount,
                        },
                      );
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
