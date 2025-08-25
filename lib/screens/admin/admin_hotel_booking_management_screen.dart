import 'package:booking_app/blocs/hotel/hotel_bloc.dart';
import 'package:booking_app/blocs/hotel/hotel_event.dart';
import 'package:booking_app/blocs/hotel/hotel_state.dart';
import 'package:booking_app/models/hotel_model.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/hotel_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminHotelBookingManagementScreenWrapper extends StatelessWidget {
  const AdminHotelBookingManagementScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('Creating HotelBloc in AdminHotelBookingManagementScreenWrapper');
    return BlocProvider(
      create:
          (context) =>
              HotelBloc(hotelService: HotelService())
                ..add(LoadAllHotelBookings()),
      child: const AdminHotelBookingManagementScreen(),
    );
  }
}

class AdminHotelBookingManagementScreen extends StatelessWidget {
  const AdminHotelBookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelBloc, HotelState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is HotelError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E1E1E),
              content: Text(
                'Lỗi: ${state.message}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          );
        } else if (state is AllHotelBookingsLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E1E1E),
              content: Text(
                'Cập nhật danh sách đặt phòng khách sạn thành công',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          );
        } else if (state is HotelBookingCancelSuccess) {
          context.read<HotelBloc>().add(LoadAllHotelBookings());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E1E1E),
              content: Text(
                'Xóa đặt phòng ${state.bookingId} thành công',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: const Color(0xFF1E1E1E),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
                  ),
                ),
                child: Text(
                  'Menu Admin',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.airplane_ticket,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Quản lý vé máy bay',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.adminBookingManagement,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.flight,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Quản lý chuyến bay',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.adminFlightManagement,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.hotel,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Quản lý đặt phòng khách sạn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.adminHotelBookingManagement,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.discount,
                        color: AppColors.primaryColor,
                      ),
                      title: Text(
                        'Quản lý mã giảm giá',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.addDiscount,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.white),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Quản lý đặt phòng khách sạn',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Builder(
                    builder:
                        (context) => IconButton(
                          icon: const Icon(Icons.menu, color: AppColors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<HotelBloc, HotelState>(
                      builder: (context, state) {
                        print('BlocBuilder received state: $state');
                        if (state is HotelLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is AllHotelBookingsLoaded) {
                          final groupedBookings =
                              <String, List<HotelBooking>>{};
                          for (var booking in state.bookings) {
                            final key = '${booking.userId}_${booking.id}';
                            groupedBookings
                                .putIfAbsent(key, () => [])
                                .add(booking);
                          }
                          return groupedBookings.isEmpty
                              ? Center(
                                child: Text(
                                  'Không có đặt phòng khách sạn nào.',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              )
                              : RefreshIndicator(
                                color: AppColors.primaryColor,
                                onRefresh: () async {
                                  print('Refreshing hotel booking list');
                                  context.read<HotelBloc>().add(
                                    LoadAllHotelBookings(),
                                  );
                                },
                                child: ListView.builder(
                                  itemCount: groupedBookings.length,
                                  itemBuilder: (context, index) {
                                    final key = groupedBookings.keys.elementAt(
                                      index,
                                    );
                                    final bookings = groupedBookings[key]!;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E1E1E),
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Đặt phòng: ${bookings.first.userId}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ...bookings.map(
                                            (booking) => HotelBookingListItem(
                                              booking: booking,
                                              onDelete: () async {
                                                print(
                                                  'Attempting to delete hotel booking: ${booking.id}',
                                                );
                                                final confirm = await showDialog<
                                                  bool
                                                >(
                                                  context: context,
                                                  builder:
                                                      (
                                                        dialogContext,
                                                      ) => AlertDialog(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF1E1E1E,
                                                            ),
                                                        title: Text(
                                                          'Xác nhận xóa',
                                                          style: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.copyWith(
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                        ),
                                                        content: Text(
                                                          'Bạn có chắc chắn muốn xóa đặt phòng này?',
                                                          style: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () => Navigator.of(
                                                                  dialogContext,
                                                                ).pop(false),
                                                            child: Text(
                                                              'Hủy',
                                                              style: Theme.of(
                                                                    context,
                                                                  )
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color:
                                                                        AppColors
                                                                            .grey,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                  ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () => Navigator.of(
                                                                  dialogContext,
                                                                ).pop(true),
                                                            child: Text(
                                                              'Xóa',
                                                              style: Theme.of(
                                                                    context,
                                                                  )
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color:
                                                                        Colors
                                                                            .redAccent,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                                if (confirm == true) {
                                                  context.read<HotelBloc>().add(
                                                    CancelHotelBooking(
                                                      booking.id,
                                                      booking.userId,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                        } else if (state is HotelError) {
                          return Center(
                            child: Text(
                              'Lỗi: ${state.message}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: Text(
                            'Khởi tạo...',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HotelBookingListItem extends StatelessWidget {
  final HotelBooking booking;
  final VoidCallback onDelete;

  const HotelBookingListItem({
    super.key,
    required this.booking,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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

        final hotelData = hotelSnapshot.data!.data() as Map<String, dynamic>;
        final hotelName = hotelData['name'] ?? 'Unknown Hotel';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF252545),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã đặt phòng: ${booking.id}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Khách sạn: $hotelName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check-in: ${DateFormat('dd MMM yyyy').format(booking.checkInDate)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check-out: ${DateFormat('dd MMM yyyy').format(booking.checkOutDate)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tổng giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(booking.totalPrice)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onDelete,
                  child: const Text(
                    'Xóa',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
