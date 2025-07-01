import 'package:flutter/material.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/utils/app_colors.dart';

class PassengerForm extends StatefulWidget {
  final void Function(Passenger passenger) onSubmit;

  const PassengerForm({super.key, required this.onSubmit});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _birthYearController = TextEditingController();
  String? _gender;
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _birthYearController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
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
            controller: _lastNameController,
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
            controller: _idNumberController,
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
            controller: _birthYearController,
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
            onChanged: (value) => _gender = value,
            validator:
                (value) => value == null ? 'Vui lòng chọn giới tính' : null,
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
                final passenger = Passenger(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  idNumber: _idNumberController.text,
                  birthYear: int.parse(_birthYearController.text),
                  gender: _gender!,
                  phoneNumber: _phoneNumberController.text,
                  email: _emailController.text,
                );
                widget.onSubmit(passenger);
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
