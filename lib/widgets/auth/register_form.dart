import 'package:booking_app/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/auth/auth_bloc.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_text_field.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
import 'package:booking_app/routes/app_routes.dart';

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
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.flight_takeoff,
            size: 48,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Tham gia ngay hôm nay',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo tài khoản để bắt đầu hành trình',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
            child: Text(
              'Đã có tài khoản? Đăng nhập ngay',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
