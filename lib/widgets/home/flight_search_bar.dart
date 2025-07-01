// widgets/home/flight_search_bar.dart
// Widget thanh tìm kiếm chuyến bay
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/routes/app_routes.dart';

class FlightSearchBar extends StatelessWidget {
  const FlightSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.dateSelection);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.grey_2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.search, color: AppColors.primaryColor),
            ),
            Text(
              'Tìm kiếm chuyến bay',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
