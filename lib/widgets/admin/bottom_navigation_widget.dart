import 'package:flutter/material.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/utils/app_colors.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationWidget({super.key, required this.currentIndex});

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) {
      return; // Không điều hướng nếu đang ở màn hình hiện tại
    }
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.adminFlightManagement,
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.adminBookingManagement,
        );
        break;
      case 3:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.adminHotelBookingManagement,
        );
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.adminProfile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
      ),
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flight, size: 24),
          label: 'Chuyến bay',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket, size: 24),
          label: 'Vé máy bay',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.hotel, size: 24),
          label: 'Đặt phòng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: 24),
          label: 'Profile',
        ),
      ],
    );
  }
}
