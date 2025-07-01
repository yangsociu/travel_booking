// register_form.dart
// register_form.dart
// Widget form đăng ký
import 'package:booking_app/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/auth/auth_bloc.dart';
import 'package:booking_app/widgets/common/custom_text_field.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
import 'package:booking_app/utils/app_colors.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'Mật khẩu',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Xác nhận mật khẩu',
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Đăng Ký',
          onPressed: () {
            if (_passwordController.text == _confirmPasswordController.text) {
              context.read<AuthBloc>().add(
                RegisterRequested(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mật khẩu không khớp')),
              );
            }
          },
        ),
      ],
    );
  }
}
