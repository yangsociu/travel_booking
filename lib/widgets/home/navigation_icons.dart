// widgets/home/navigation_icons.dart
// Widget hiển thị các biểu tượng điều hướng
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class NavigationIcons extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onIconSelected;

  const NavigationIcons({
    super.key,
    required this.selectedIndex,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(
          iconPath: 'assets/icons/home/plane.png',
          index: 0,
          width: 26,
          height: 26,
        ),
        _buildIconButton(
          iconPath: 'assets/icons/home/hotel.png',
          index: 1,
          width: 42,
          height: 42,
        ),
        _buildIconButton(
          iconPath: 'assets/icons/home/icon_taxi.png',
          index: 2,
          width: 35,
          height: 36,
        ),
        _buildIconButton(
          iconPath: 'assets/icons/home/icon_more.png',
          index: 3,
          width: 35,
          height: 37,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required int index,
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => onIconSelected(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border:
              selectedIndex == index
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          iconPath,
          width: width,
          height: height,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
