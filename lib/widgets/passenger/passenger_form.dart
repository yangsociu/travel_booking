import 'package:flutter/material.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/utils/app_colors.dart';

class PassengerForm extends StatefulWidget {
  final void Function(
    List<Passenger> passengers,
    String phoneNumber,
    String email,
  )
  onSubmit;
  final int passengerCount;

  const PassengerForm({
    super.key,
    required this.onSubmit,
    required this.passengerCount,
  });

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, TextEditingController>> _passengerControllers = [];
  List<String?> _genders = [];
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final passengerCount = widget.passengerCount;
    _passengerControllers = List.generate(
      passengerCount,
      (index) => {
        'fullName': TextEditingController(),
        'birthYear': TextEditingController(),
      },
    );
    _genders = List.generate(passengerCount, (_) => null);
  }

  @override
  void dispose() {
    for (var controllers in _passengerControllers) {
      controllers['fullName']!.dispose();
      controllers['birthYear']!.dispose();
    }
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form cho từng hành khách
            for (int i = 0; i < widget.passengerCount; i++) ...[
              Text(
                'Hành khách ${i + 1}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passengerControllers[i]['fullName'],
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  labelStyle: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Vui lòng nhập họ và tên' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passengerControllers[i]['birthYear'],
                decoration: const InputDecoration(
                  labelText: 'Năm sinh',
                  labelStyle: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty || int.tryParse(value) == null
                            ? 'Vui lòng nhập năm sinh hợp lệ'
                            : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  labelStyle: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                  ),
                  border: OutlineInputBorder(),
                ),
                items:
                    ['Nam', 'Nữ'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _genders[i] = value),
                validator:
                    (value) => value == null ? 'Vui lòng chọn giới tính' : null,
              ),
              const SizedBox(height: 20),
            ],
            // Thông tin liên hệ
            const Text(
              'Thông tin liên hệ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'Montserrat',
              ),
              keyboardType: TextInputType.phone,
              validator:
                  (value) =>
                      value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'Montserrat',
              ),
              keyboardType: TextInputType.emailAddress,
              validator:
                  (value) =>
                      value!.isEmpty || !value.contains('@')
                          ? 'Vui lòng nhập email hợp lệ'
                          : null,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final passengers = <Passenger>[];
                    for (int i = 0; i < widget.passengerCount; i++) {
                      passengers.add(
                        Passenger(
                          fullName: _passengerControllers[i]['fullName']!.text,
                          birthYear:
                              int.tryParse(
                                _passengerControllers[i]['birthYear']!.text,
                              ) ??
                              0,
                          gender: _genders[i]!,
                          phoneNumber: _phoneNumberController.text,
                          email: _emailController.text,
                        ),
                      );
                    }
                    widget.onSubmit(
                      passengers,
                      _phoneNumberController.text,
                      _emailController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Xác nhận',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
