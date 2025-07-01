// widgets/home/custom_bottom_navigation.dart
// Widget thanh điều hướng dưới
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': 'assets/icons/home/material-symbols_home-outline-rounded.png',
        'size': 42.0,
      },
      {'icon': 'assets/icons/home/material-symbols_search.png', 'size': 37.0},
      {
        'icon': 'assets/icons/home/material-symbols_map-outline.png',
        'size': 40.0,
      },
      {'icon': 'assets/icons/home/mdi_user.png', 'size': 42.0},
    ];

    return Container(
      height: 60.0,
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    currentIndex == index
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                items[index]['icon'],
                width: items[index]['size'],
                height: items[index]['size'],
                color: AppColors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
