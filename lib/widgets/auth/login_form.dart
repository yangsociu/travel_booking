// login_form.dart
// login_form.dart
// Widget form đăng nhập
import 'package:booking_app/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/auth/auth_bloc.dart';
import 'package:booking_app/widgets/common/custom_text_field.dart';
import 'package:booking_app/widgets/common/custom_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        const SizedBox(height: 20),
        CustomButton(
          text: 'Đăng Nhập',
          onPressed: () {
            context.read<AuthBloc>().add(
              LoginRequested(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
          },
        ),
      ],
    );
  }
}
