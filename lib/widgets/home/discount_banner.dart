import 'package:booking_app/models/discount_model.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    if (userId.isNotEmpty) {
      context.read<HomeBloc>().add(CheckDiscountClaimed(userId));
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return LoadingWidget(
          isLoading: state.isLoading,
          error: state.error,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ưu đãi giảm giá',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
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
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: PageView(
                  controller: PageController(viewportFraction: 0.85),
                  children:
                      state.discounts
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildBanner(
                              context: context,
                              discount: entry.value,
                              isClaimed: state.claimedDiscountCodes.contains(
                                entry.value.code,
                              ),
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
    required DiscountModel discount,
    required bool isClaimed,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Container(
      width: 300,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 50,
              height: 50,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Icon(
                Icons.discount,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 16,
            child: SizedBox(
              width: 180,
              child: Text(
                'Mã: ${discount.code}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 42,
            child: SizedBox(
              width: 180,
              child: Text(
                discount.validUntil != null
                    ? 'Giảm ${discount.discountPercentage}% đến ${dateFormat.format(discount.validUntil!)}'
                    : 'Giảm ${discount.discountPercentage}% (Không có ngày hết hạn)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 30,
            child: ElevatedButton(
              onPressed:
                  isClaimed
                      ? null
                      : () {
                        final user =
                            firebase_auth.FirebaseAuth.instance.currentUser;
                        final userId = user?.uid ?? '';
                        if (userId.isNotEmpty) {
                          context.read<FlightService>().saveUsedDiscount(
                            userId,
                            discount.code,
                            '',
                          );
                          context.read<HomeBloc>().add(
                            SelectDiscount(discount.code),
                          );
                          context.read<HomeBloc>().add(
                            CheckDiscountClaimed(userId),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã nhận mã ${discount.code}!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Vui lòng đăng nhập để nhận mã giảm giá!',
                              ),
                            ),
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isClaimed
                        ? AppColors.grey.withOpacity(0.5)
                        : AppColors.primaryColor,
                foregroundColor: AppColors.white,
                minimumSize: const Size(90, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: Text(
                isClaimed ? 'Đã nhận' : 'Nhận',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
