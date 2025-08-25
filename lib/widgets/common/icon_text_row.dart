import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

class IconTextRow extends StatelessWidget {
  final String iconPath;
  final String text;
  final TextStyle? textStyle;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final double spacing;

  const IconTextRow({
    super.key,
    required this.iconPath,
    required this.text,
    this.textStyle,
    this.iconWidth = 24.0,
    this.iconHeight = 24.0,
    this.iconColor = AppColors.black,
    this.spacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: iconWidth,
          height: iconHeight,
          color: iconColor,
        ),
        SizedBox(width: spacing),
        Text(text, style: textStyle),
      ],
    );
  }
}
