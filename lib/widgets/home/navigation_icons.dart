import 'package:flutter/cupertino.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(icon: CupertinoIcons.airplane, index: 0, size: 30),
          _buildIconButton(
            icon: CupertinoIcons.building_2_fill,
            index: 1,
            size: 30,
          ),
          _buildIconButton(
            icon: CupertinoIcons.ellipsis_circle,
            index: 2,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required int index,
    required double size,
  }) {
    return GestureDetector(
      onTap: () => onIconSelected(index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selectedIndex == index
                  ? AppColors.primaryColor.withOpacity(0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          gradient:
              selectedIndex == index
                  ? LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.2),
                      AppColors.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          boxShadow: [
            if (selectedIndex == index)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Icon(
          icon,
          size: size,
          color:
              selectedIndex == index
                  ? AppColors.primaryColor
                  : AppColors.grey.withOpacity(0.7),
        ),
      ),
    );
  }
}
