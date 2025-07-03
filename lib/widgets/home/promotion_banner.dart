import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/loading_widget.dart';

class PromotionBanner extends StatelessWidget {
  const PromotionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return LoadingWidget(
          isLoading: state.isLoading,
          error: state.error,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hãng hàng không',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Xử lý sự kiện khi nhấn "Xem thêm"
                    },
                    child: Text(
                      'Xem thêm',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 73,
                child: PageView(
                  controller: PageController(viewportFraction: 0.65),
                  children:
                      state.airlines
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildBanner(
                              context: context,
                              airline: entry.value.name,
                              price: entry.value.price,
                              image: entry.value.image,
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner({
    required BuildContext context,
    required String airline,
    required String price,
    required String image,
  }) {
    return Container(
      width: 250,
      height: 73,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 290,
              height: 73,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 7,
            top: 9,
            child: Container(
              width: 55,
              height: 55,
              decoration: ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 68,
            top: 25,
            child: SizedBox(
              width: 150,
              child: Text(
                airline,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.44,
                ),
              ),
            ),
          ),
          Positioned(
            left: 68,
            top: 50,
            child: const SizedBox(
              width: 60,
              height: 20,
              child: Text(
                'Chỉ từ',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                ),
              ),
            ),
          ),
          Positioned(
            left: 140,
            top: 50,
            child: SizedBox(
              width: 58,
              height: 20,
              child: Text(
                price,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.12,
                ),
              ),
            ),
          ),
          Positioned(
            left: 68,
            top: 9,
            child: Row(
              children: List.generate(
                5,
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
