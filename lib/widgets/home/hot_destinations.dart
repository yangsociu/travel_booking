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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Điểm đến nổi bật',
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
              const SizedBox(height: 24),
              SizedBox(
                height: 326,
                child: PageView(
                  controller: PageController(viewportFraction: 0.78),
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
    double width = 260.0;
    double height = 340.0;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                left: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  child: Image.asset(
                    destination.image,
                    width: width,
                    height: height * 0.5583,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.0814,
                top: height * 0.6166,
                child: Text(
                  destination.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.44,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.6938,
                top: height * 0.6074,
                child: Text(
                  destination.price,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 0.96,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.0814,
                top: height * 0.7086,
                child: SizedBox(
                  width: width * 0.8488,
                  height: height * 0.1503,
                  child: Text(
                    destination.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.29,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.0814,
                top: height * 0.9018,
                child: Container(
                  width: width * 0.4496,
                  height: height * 0.0675,
                  decoration: ShapeDecoration(
                    color: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Tìm hiểu thêm',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.29,
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
