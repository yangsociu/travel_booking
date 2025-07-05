import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/models/destination_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/loading_widget.dart';

class HotDestinations extends StatelessWidget {
  const HotDestinations({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Điểm đến nổi bật',
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
              const SizedBox(height: 20),
              SizedBox(
                height: 380,
                child: PageView(
                  controller: PageController(viewportFraction: 0.82),
                  children:
                      state.destinations
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildDestinationCard(
                              context: context,
                              index: entry.key,
                              destination: entry.value,
                              isSelected:
                                  state.selectedDestinationIndex == entry.key,
                              onTap: () {
                                context.read<HomeBloc>().add(
                                  SelectDestination(entry.key),
                                );
                              },
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

  Widget _buildDestinationCard({
    required BuildContext context,
    required int index,
    required DestinationModel destination,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    double width = 300.0;
    double height = 380.0;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: width,
                  height: height,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    destination.image,
                    width: width,
                    height: height * 0.62,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.08,
                top: height * 0.65,
                child: Text(
                  destination.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: AppColors.black,
                  ),
                ),
              ),
              Positioned(
                right: width * 0.08,
                top: height * 0.65,
                child: Text(
                  destination.price,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.08,
                top: height * 0.74,
                child: SizedBox(
                  width: width * 0.84,
                  height: height * 0.13,
                  child: Text(
                    destination.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      color: AppColors.grey.withOpacity(0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.08,
                bottom: height * 0.04,
                child: Container(
                  width: width * 0.5,
                  height: height * 0.09,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Tìm hiểu thêm',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
