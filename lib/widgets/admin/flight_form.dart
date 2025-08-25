import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/airline_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_event.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:intl/intl.dart';

class FlightForm extends StatefulWidget {
  final FlightModel? flight;

  const FlightForm({super.key, this.flight});

  @override
  _FlightFormState createState() => _FlightFormState();
}

class _FlightFormState extends State<FlightForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _flightIdController;
  late TextEditingController _priceController;
  String? _departureCity;
  String? _arrivalCity;
  String? _departureAirportName;
  String? _arrivalAirportName;
  String? _departureAirportCode;
  String? _arrivalAirportCode;
  String? _airlineId;
  DateTime? _departureTime;
  DateTime? _arrivalTime;
  List<Map<String, String>> _cities = [];
  List<AirlineModel> _airlines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _flightIdController = TextEditingController(text: widget.flight?.id ?? '');
    _priceController = TextEditingController(
      text: widget.flight?.price.toString() ?? '',
    );
    _departureCity = widget.flight?.departureCity;
    _arrivalCity = widget.flight?.arrivalCity;
    _departureAirportName = widget.flight?.departureAirportName;
    _arrivalAirportName = widget.flight?.arrivalAirportName;
    _departureAirportCode = widget.flight?.departureAirportCode;
    _arrivalAirportCode = widget.flight?.arrivalAirportCode;
    _airlineId = widget.flight?.airlineId;
    _departureTime = widget.flight?.departureTime ?? DateTime.now();
    _arrivalTime =
        widget.flight?.arrivalTime ??
        DateTime.now().add(const Duration(hours: 1, minutes: 30));

    // Log để debug
    print('Initial flight data: ${widget.flight?.toJson()}');
    print('Initial _airlineId: $_airlineId');

    _loadData();
  }

  @override
  void dispose() {
    _flightIdController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Future.wait([_loadCities(), _loadAirlines()]);
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCities() async {
    try {
      final cities = await context.read<FlightService>().getCities();
      setState(() {
        _cities = cities;
      });
      print('Loaded cities: ${cities.length}');
    } catch (e) {
      print('Error loading cities: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách thành phố: $e'),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
      );
    }
  }

  Future<void> _loadAirlines() async {
    try {
      final airlines = await context.read<FlightService>().getAirlines();
      setState(() {
        _airlines = airlines;
        // Đảm bảo _airlineId hợp lệ
        if (_airlineId != null &&
            !airlines.any((airline) => airline.id == _airlineId)) {
          print(
            'Current _airlineId $_airlineId not found in airlines, resetting to null',
          );
          _airlineId = airlines.isNotEmpty ? airlines.first.id : null;
        }
      });
      print('Loaded airlines: ${airlines.map((a) => a.name).toList()}');
    } catch (e) {
      print('Error loading airlines: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải danh sách hãng hàng không: $e'),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isDeparture
              ? _departureTime ?? DateTime.now()
              : _arrivalTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isDeparture
              ? _departureTime ?? DateTime.now()
              : _arrivalTime ?? DateTime.now(),
        ),
      );
      if (pickedTime != null && context.mounted) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isDeparture) {
            _departureTime = selectedDateTime;
            if (_arrivalTime == null ||
                _arrivalTime!.isBefore(
                  selectedDateTime.add(const Duration(hours: 1, minutes: 30)),
                )) {
              _arrivalTime = selectedDateTime.add(
                const Duration(hours: 1, minutes: 30),
              );
            }
          } else {
            _arrivalTime = selectedDateTime;
          }
        });
        print(
          'Selected ${isDeparture ? "departure" : "arrival"} time: $selectedDateTime',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.flight == null ? 'Thêm chuyến bay' : 'Sửa chuyến bay',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _flightIdController,
                  decoration: InputDecoration(
                    labelText: 'Mã chuyến bay',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                  validator: (value) {
                    if (widget.flight == null &&
                        (value == null || value.isEmpty)) {
                      return 'Vui lòng nhập mã chuyến bay hoặc để trống để tự động tạo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: const Color(0xFF1E1E1E)),
                  child: DropdownButtonFormField<String>(
                    value: _departureCity,
                    decoration: InputDecoration(
                      labelText: 'Điểm đi',
                      labelStyle: const TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Montserrat',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.white.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      fillColor: const Color(0xFF1E1E1E),
                      filled: true,
                    ),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    dropdownColor: const Color(0xFF1E1E1E),
                    items:
                        _cities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city['name'],
                                child: Text(
                                  city['name']!,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == _arrivalCity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Điểm đi và điểm đến không được trùng nhau',
                            ),
                            backgroundColor: Color(0xFF1E1E1E),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _departureCity = value;
                        final city = _cities.firstWhere(
                          (c) => c['name'] == value,
                          orElse:
                              () => {
                                'name': 'UNKNOWN',
                                'airportName': 'UNKNOWN',
                                'airportCode': 'UNKNOWN',
                              },
                        );
                        _departureAirportName = city['airportName'];
                        _departureAirportCode = city['airportCode'];
                      });
                      print(
                        'Selected departure city: $_departureCity, airport: $_departureAirportName, code: $_departureAirportCode',
                      );
                    },
                    validator:
                        (value) =>
                            value == null ? 'Vui lòng chọn điểm đi' : null,
                    hint: Text(
                      _cities.isEmpty ? 'Không có thành phố' : 'Chọn điểm đi',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController(
                    text: _departureAirportName ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tên sân bay đi',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController(
                    text: _departureAirportCode ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mã sân bay đi',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: const Color(0xFF1E1E1E)),
                  child: DropdownButtonFormField<String>(
                    value: _arrivalCity,
                    decoration: InputDecoration(
                      labelText: 'Điểm đến',
                      labelStyle: const TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Montserrat',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.white.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      fillColor: const Color(0xFF1E1E1E),
                      filled: true,
                    ),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    dropdownColor: const Color(0xFF1E1E1E),
                    items:
                        _cities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city['name'],
                                child: Text(
                                  city['name']!,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == _departureCity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Điểm đến và điểm đi không được trùng nhau',
                            ),
                            backgroundColor: Color(0xFF1E1E1E),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _arrivalCity = value;
                        final city = _cities.firstWhere(
                          (c) => c['name'] == value,
                          orElse:
                              () => {
                                'name': 'UNKNOWN',
                                'airportName': 'UNKNOWN',
                                'airportCode': 'UNKNOWN',
                              },
                        );
                        _arrivalAirportName = city['airportName'];
                        _arrivalAirportCode = city['airportCode'];
                      });
                      print(
                        'Selected arrival city: $_arrivalCity, airport: $_arrivalAirportName, code: $_arrivalAirportCode',
                      );
                    },
                    validator:
                        (value) =>
                            value == null ? 'Vui lòng chọn điểm đến' : null,
                    hint: Text(
                      _cities.isEmpty ? 'Không có thành phố' : 'Chọn điểm đến',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController(
                    text: _arrivalAirportName ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tên sân bay đến',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: TextEditingController(
                    text: _arrivalAirportCode ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mã sân bay đến',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 12),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: const Color(0xFF1E1E1E)),
                  child: DropdownButtonFormField<String>(
                    value:
                        _airlines.any((airline) => airline.id == _airlineId)
                            ? _airlineId
                            : null,
                    decoration: InputDecoration(
                      labelText: 'Hãng hàng không',
                      labelStyle: const TextStyle(
                        color: AppColors.grey,
                        fontFamily: 'Montserrat',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.white.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      fillColor: const Color(0xFF1E1E1E),
                      filled: true,
                    ),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    dropdownColor: const Color(0xFF1E1E1E),
                    items:
                        _airlines.isEmpty
                            ? [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'Không có hãng hàng không',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.5),
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                enabled: false,
                              ),
                            ]
                            : _airlines.map((airline) {
                              return DropdownMenuItem<String>(
                                value: airline.id,
                                child: Text(
                                  airline.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              );
                            }).toList(),
                    onChanged:
                        _airlines.isEmpty
                            ? null
                            : (value) {
                              setState(() {
                                _airlineId = value;
                              });
                              print('Selected airline ID: $value');
                            },
                    validator:
                        (value) =>
                            value == null
                                ? 'Vui lòng chọn hãng hàng không'
                                : null,
                    hint: Text(
                      _airlines.isEmpty
                          ? 'Không có hãng hàng không'
                          : 'Chọn hãng hàng không',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá vé',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty || double.tryParse(value) == null
                              ? 'Vui lòng nhập giá hợp lệ'
                              : null,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(
                    _departureTime == null
                        ? 'Chọn thời gian khởi hành'
                        : DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(_departureTime!),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                  ),
                  onTap: () => _selectDateTime(context, true),
                  tileColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(
                    _arrivalTime == null
                        ? 'Chọn thời gian đến'
                        : DateFormat('dd/MM/yyyy HH:mm').format(_arrivalTime!),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                  ),
                  onTap: () => _selectDateTime(context, false),
                  tileColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _airlines.isEmpty
                          ? null
                          : () {
                            if (_formKey.currentState!.validate() &&
                                _departureTime != null &&
                                _arrivalTime != null &&
                                _departureCity != null &&
                                _arrivalCity != null &&
                                _departureAirportName != null &&
                                _arrivalAirportName != null &&
                                _departureAirportCode != null &&
                                _arrivalAirportCode != null &&
                                _airlineId != null) {
                              if (_departureCity == _arrivalCity) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Điểm đi và điểm đến không được trùng nhau',
                                    ),
                                    backgroundColor: Color(0xFF1E1E1E),
                                  ),
                                );
                                return;
                              }
                              if (widget.flight != null &&
                                  (widget.flight!.documentId.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Không thể cập nhật: ID tài liệu không hợp lệ',
                                    ),
                                    backgroundColor: Color(0xFF1E1E1E),
                                  ),
                                );
                                return;
                              }
                              final flight = FlightModel(
                                id:
                                    _flightIdController.text.isEmpty
                                        ? 'AUTO_${DateTime.now().millisecondsSinceEpoch}'
                                        : _flightIdController.text,
                                documentId:
                                    widget.flight?.documentId ??
                                    'AUTO_${DateTime.now().millisecondsSinceEpoch}',
                                departureCity: _departureCity!,
                                arrivalCity: _arrivalCity!,
                                departureAirportName: _departureAirportName!,
                                arrivalAirportName: _arrivalAirportName!,
                                departureAirportCode: _departureAirportCode!,
                                arrivalAirportCode: _arrivalAirportCode!,
                                departureTime: _departureTime!,
                                arrivalTime: _arrivalTime!,
                                price: double.parse(_priceController.text),
                                airlineId: _airlineId!,
                              );
                              print('Submitting flight: ${flight.toJson()}');
                              context.read<AdminFlightBloc>().add(
                                widget.flight == null
                                    ? AddFlight(flight)
                                    : UpdateFlight(flight),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color(0xFF1E1E1E),
                                  content: Text(
                                    'Vui lòng điền đầy đủ thông tin',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.flight == null ? 'Thêm' : 'Cập nhật',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
