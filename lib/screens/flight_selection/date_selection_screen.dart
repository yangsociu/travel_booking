import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/flight_search/flight_search_bloc.dart';
import 'package:booking_app/blocs/flight_search/flight_search_event.dart';
import 'package:booking_app/blocs/flight_search/flight_search_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/widgets/flight_selection/city_selector.dart';
import 'package:booking_app/widgets/flight_selection/date_selector.dart';
import 'package:booking_app/widgets/flight_selection/passenger_picker.dart';
import 'package:booking_app/utils/app_colors.dart';
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
        backgroundColor: AppColors.grey_2,
        appBar: AppBar(
          title: const Text(
            'Chọn ngày',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hàng 1: Radio Button cho Một chiều và Khứ hồi
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: state.isRoundTrip,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<FlightSearchBloc>().add(
                                      ToggleRoundTrip(value),
                                    );
                                  }
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<FlightSearchBloc>().add(
                                    ToggleRoundTrip(false),
                                  );
                                },
                                child: Text(
                                  'Một chiều',
                                  style: TextStyle(
                                    color:
                                        !state.isRoundTrip
                                            ? AppColors.black
                                            : AppColors.primaryColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight:
                                        !state.isRoundTrip
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Radio<bool>(
                                value: true,
                                groupValue: state.isRoundTrip,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<FlightSearchBloc>().add(
                                      ToggleRoundTrip(value),
                                    );
                                  }
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<FlightSearchBloc>().add(
                                    ToggleRoundTrip(true),
                                  );
                                },
                                child: Text(
                                  'Khứ hồi',
                                  style: TextStyle(
                                    color:
                                        state.isRoundTrip
                                            ? AppColors.black
                                            : AppColors.primaryColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight:
                                        state.isRoundTrip
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Tăng khoảng cách
                      // Hàng 2: Điểm đi, Nút đổi, Điểm đến
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CitySelector(
                                  label: 'Điểm đi',
                                  selectedCity: state.departureCity,
                                  iconPath:
                                      'assets/icons/date_selection_screen/tdesign_location-filled.png',
                                  onTap: () => _showCityPicker(context, true),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.swap_horiz,
                                    color: AppColors.primaryColor,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    context.read<FlightSearchBloc>().add(
                                      SwapCities(),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: CitySelector(
                                  label: 'Điểm đến',
                                  selectedCity: state.arrivalCity,
                                  iconPath:
                                      'assets/icons/date_selection_screen/tdesign_location-filled.png',
                                  onTap: () => _showCityPicker(context, false),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Tăng khoảng cách
                      // Hàng 3: Ngày đi
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return DateSelector(
                            label: 'Ngày đi',
                            selectedDate: state.departureDate,
                            onTap: () => _selectDate(context, true),
                            isEnabled: true,
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Tăng khoảng cách
                      // Hàng 4: Ngày về
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return DateSelector(
                            label: 'Ngày về',
                            selectedDate: state.returnDate,
                            onTap:
                                state.isRoundTrip
                                    ? () => _selectDate(context, false)
                                    : null,
                            isEnabled: state.isRoundTrip,
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Tăng khoảng cách
                      // Hàng 5: Số khách
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return PassengerPicker(
                            passengerCount: state.passengerCount,
                            onTap: () => _showPassengerPicker(context),
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Tăng khoảng cách
                      // Hàng 6: Nút tìm chuyến bay
                      BlocBuilder<FlightSearchBloc, FlightSearchState>(
                        builder: (context, state) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  state.canSearch
                                      ? () {
                                        context.read<FlightSearchBloc>().add(
                                          SearchFlights(),
                                        );
                                      }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Tìm chuyến bay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
