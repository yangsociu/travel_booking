import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/hotel/hotel_bloc.dart';
import 'package:booking_app/blocs/hotel/hotel_event.dart';
import 'package:booking_app/blocs/hotel/hotel_state.dart';
import 'package:booking_app/services/hotel_service.dart';
import 'package:booking_app/widgets/hotel/hotel_card.dart';
import 'package:booking_app/utils/app_colors.dart';

class HotelListScreen extends StatelessWidget {
  final HotelService hotelService;

  const HotelListScreen({super.key, required this.hotelService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HotelBloc(hotelService: hotelService)..add(LoadHotels()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Khách Sạn',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.search),
              onPressed: () {
                // Chỗ để thêm logic tìm kiếm sau
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm khách sạn...',
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  // Chỗ để thêm logic tìm kiếm sau
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<HotelBloc, HotelState>(
                builder: (context, state) {
                  print('HotelListScreen state: $state');
                  if (state is HotelLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: 5, // Skeleton placeholders
                      itemBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade100,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 150,
                                              color: Colors.grey.shade200,
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 16,
                                              width: 100,
                                              color: Colors.grey.shade200,
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 16,
                                              width: 80,
                                              color: Colors.grey.shade200,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    );
                  } else if (state is HotelLoaded) {
                    print('Hotels loaded: ${state.hotels.length}');
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.hotels.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: HotelCard(hotel: state.hotels[index]),
                        );
                      },
                    );
                  } else if (state is HotelError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.exclamationmark_circle,
                            size: 40,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lỗi: ${state.message}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Không có khách sạn nào để hiển thị',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
