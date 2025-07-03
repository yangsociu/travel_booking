// widgets/home/custom_bottom_navigation.dart
// Widget thanh điều hướng dưới
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

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
      {'icon': CupertinoIcons.home, 'size': 30.0},
      {'icon': CupertinoIcons.search, 'size': 30.0},
      {'icon': CupertinoIcons.tag_fill, 'size': 30.0},
      {'icon': CupertinoIcons.person_fill, 'size': 30.0},
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
              child: Icon(
                items[index]['icon']
                    as IconData, // Ép kiểu rõ ràng để tránh lỗi
                size: items[index]['size'] as double,
                color: AppColors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
