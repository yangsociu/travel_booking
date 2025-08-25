import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/models/hotel_model.dart';
import 'package:booking_app/services/hotel_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/blocs/hotel/hotel_bloc.dart';
import 'package:booking_app/blocs/hotel/hotel_event.dart';
import 'package:booking_app/blocs/hotel/hotel_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PastBookingsSection extends StatefulWidget {
  final String userId;
  final HotelService hotelService;

  const PastBookingsSection({
    super.key,
    required this.userId,
    required this.hotelService,
  });

  @override
  _PastBookingsSectionState createState() => _PastBookingsSectionState();
}

class _PastBookingsSectionState extends State<PastBookingsSection> {
  @override
  void initState() {
    super.initState();
    print('Sending LoadUserBookings for userId=${widget.userId}');
    context.read<HotelBloc>().add(LoadUserBookings(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelBloc, HotelState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is HotelBookingCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã hủy đặt phòng ${state.bookingId} thành công'),
            ),
          );
          context.read<HotelBloc>().add(
            LoadUserBookings(widget.userId),
          ); // Làm mới danh sách
        } else if (state is HotelError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
        }
      },
      child: BlocBuilder<HotelBloc, HotelState>(
        builder: (context, state) {
          print('BlocBuilder received state: $state');
          if (state is HotelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserBookingsLoaded) {
            final bookings = state.bookings;
            if (bookings.isEmpty) {
              return const Center(child: Text('Chưa có đặt phòng nào.'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('hotels')
                          .doc(booking.hotelId)
                          .get(),
                  builder: (context, hotelSnapshot) {
                    if (!hotelSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (hotelSnapshot.hasError) {
                      print('Error loading hotel data: ${hotelSnapshot.error}');
                      return Center(
                        child: Text(
                          'Lỗi khi tải dữ liệu khách sạn: ${hotelSnapshot.error}',
                        ),
                      );
                    }

                    final hotelData =
                        hotelSnapshot.data!.data() as Map<String, dynamic>;
                    final hotelName = hotelData['name'] ?? 'Unknown Hotel';
                    final hotelImage = hotelData['imageUrl'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đặt phòng: ${booking.id}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              hotelImage.isNotEmpty
                                  ? Image.asset(
                                    hotelImage,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.hotel,
                                          size: 40,
                                          color: AppColors.grey.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                  )
                                  : Icon(
                                    Icons.hotel,
                                    size: 40,
                                    color: AppColors.grey.withOpacity(0.5),
                                  ),
                              const SizedBox(width: 8),
                              Text(
                                'Khách sạn: $hotelName',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Địa điểm: ${hotelData['location'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Check-in: ${DateFormat('dd MMM yyyy').format(booking.checkInDate)}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Check-out: ${DateFormat('dd MMM yyyy').format(booking.checkOutDate)}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tổng giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(booking.totalPrice)}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Thời gian đặt: ${DateFormat('HH:mm dd MMM yyyy').format(booking.checkInDate)}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                  'Cancel button pressed for bookingId=${booking.id}, userId=${widget.userId}',
                                );
                                context.read<HotelBloc>().add(
                                  CancelHotelBooking(booking.id, widget.userId),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                minimumSize: const Size(100, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is HotelError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          } else {
            return const Center(child: Text('Chưa có đặt phòng nào.'));
          }
        },
      ),
    );
  }
}
