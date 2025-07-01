// header.dart
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Image.asset('assets/icons/home/3gach.png', width: 24, height: 24),
        onPressed: () {
          // Xử lý sự kiện khi nhấn vào biểu tượng menu
        },
      ),
      title: const Text(
        'Home',
        style: TextStyle(color: AppColors.black, fontFamily: 'Montserrat'),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/icons/home/avatar.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            // Xử lý sự kiện khi nhấn vào avatar
          },
        ),
      ],
      backgroundColor: AppColors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
