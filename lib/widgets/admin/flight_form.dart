// flight_form.dart
import 'package:flutter/material.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_event.dart';

class FlightForm extends StatefulWidget {
  final FlightModel? flight;

  const FlightForm({super.key, this.flight});

  @override
  _FlightFormState createState() => _FlightFormState();
}

class _FlightFormState extends State<FlightForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _flightIdController;
  late TextEditingController _departureCityController;
  late TextEditingController _arrivalCityController;
  late TextEditingController _departureCodeController;
  late TextEditingController _arrivalCodeController;
  late TextEditingController _priceController;
  DateTime? _departureTime;
  DateTime? _arrivalTime;

  @override
  void initState() {
    super.initState();
    _flightIdController = TextEditingController(text: widget.flight?.id ?? '');
    _departureCityController = TextEditingController(
      text: widget.flight?.departureCity ?? '',
    );
    _arrivalCityController = TextEditingController(
      text: widget.flight?.arrivalCity ?? '',
    );
    _departureCodeController = TextEditingController(
      text: widget.flight?.departureCode ?? '',
    );
    _arrivalCodeController = TextEditingController(
      text: widget.flight?.arrivalCode ?? '',
    );
    _priceController = TextEditingController(
      text: widget.flight?.price.toString() ?? '',
    );
    _departureTime = widget.flight?.departureTime ?? DateTime.now();
    _arrivalTime =
        widget.flight?.arrivalTime ??
        DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _flightIdController.dispose();
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _departureCodeController.dispose();
    _arrivalCodeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
          } else {
            _arrivalTime = selectedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _flightIdController,
                decoration: InputDecoration(
                  labelText: 'Mã chuyến bay',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
              TextFormField(
                controller: _departureCityController,
                decoration: InputDecoration(
                  labelText: 'Điểm đi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Vui lòng nhập điểm đi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _arrivalCityController,
                decoration: InputDecoration(
                  labelText: 'Điểm đến',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Vui lòng nhập điểm đến' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _departureCodeController,
                decoration: InputDecoration(
                  labelText: 'Mã điểm đi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Vui lòng nhập mã điểm đi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _arrivalCodeController,
                decoration: InputDecoration(
                  labelText: 'Mã điểm đến',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Vui lòng nhập mã điểm đến' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Giá vé',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                      : _departureTime!.toIso8601String(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: AppColors.black,
                ),
                onTap: () => _selectDateTime(context, true),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _arrivalTime == null
                      ? 'Chọn thời gian đến'
                      : _arrivalTime!.toIso8601String(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: AppColors.black,
                ),
                onTap: () => _selectDateTime(context, false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _departureTime != null &&
                      _arrivalTime != null) {
                    final flight = FlightModel(
                      id:
                          _flightIdController
                              .text, // Mã chuyến bay từ người dùng
                      documentId:
                          widget.flight?.documentId ??
                          '', // Để rỗng khi thêm mới
                      departureCity: _departureCityController.text,
                      arrivalCity: _arrivalCityController.text,
                      departureCode: _departureCodeController.text,
                      arrivalCode: _arrivalCodeController.text,
                      departureTime: _departureTime!,
                      arrivalTime: _arrivalTime!,
                      price: double.parse(_priceController.text),
                    );
                    context.read<AdminFlightBloc>().add(
                      widget.flight == null
                          ? AddFlight(flight)
                          : UpdateFlight(flight),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin'),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.flight == null ? 'Thêm' : 'Cập nhật',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
