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
    // Get passenger count from arguments or default to 1
    final passengerCount = widget.passengerCount;
    _passengerControllers = List.generate(
      passengerCount,
      (index) => {
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'idNumber': TextEditingController(),
        'birthYear': TextEditingController(),
      },
    );
    _genders = List.generate(passengerCount, (_) => null);
  }

  void dispose() {
    for (var controllers in _passengerControllers) {
      controllers['firstName']!.dispose();
      controllers['lastName']!.dispose();
      controllers['idNumber']!.dispose();
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
              controller: _passengerControllers[i]['firstName'],
              decoration: const InputDecoration(
                labelText: 'Tên',
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
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passengerControllers[i]['lastName'],
              decoration: const InputDecoration(
                labelText: 'Họ và Tên Đệm',
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
                      value!.isEmpty ? 'Vui lòng nhập họ và tên đệm' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passengerControllers[i]['idNumber'],
              decoration: const InputDecoration(
                labelText: 'Số CCCD/Passport',
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
                      value!.isEmpty ? 'Vui lòng nhập số CCCD/Passport' : null,
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
          ],
          // Thông tin chung
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final passengers = <Passenger>[];
                for (int i = 0; i < widget.passengerCount; i++) {
                  passengers.add(
                    Passenger(
                      firstName: _passengerControllers[i]['firstName']!.text,
                      lastName: _passengerControllers[i]['lastName']!.text,
                      idNumber: _passengerControllers[i]['idNumber']!.text,
                      birthYear:
                          int.tryParse(
                            _passengerControllers[i]['birthYear']!.text,
                          ) ??
                          0,
                      gender: _genders[i]!,
                      phoneNumber:
                          _phoneNumberController
                              .text, // truyền số điện thoại liên hệ
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
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
