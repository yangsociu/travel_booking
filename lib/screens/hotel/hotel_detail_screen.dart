import 'package:booking_app/blocs/hotel/hotel_state.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_app/models/hotel_model.dart';
import 'package:booking_app/blocs/hotel/hotel_bloc.dart';
import 'package:booking_app/blocs/hotel/hotel_event.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class HotelDetailScreen extends StatefulWidget {
  final HotelModel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  DateTime? checkInDate = DateTime(2025, 7, 7, 14, 16, 3);
  DateTime? checkOutDate = DateTime(2025, 7, 8, 14, 16, 3);

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.grey.shade100,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        if (checkOutDate == null ||
            checkOutDate!.isBefore(picked) ||
            checkOutDate!.isAtSameMomentAs(picked)) {
          checkOutDate = picked.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          checkOutDate ??
          (checkInDate?.add(const Duration(days: 1)) ?? DateTime.now()),
      firstDate: checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.grey.shade100,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  double _calculateTotalPrice() {
    if (checkInDate == null || checkOutDate == null) {
      return widget.hotel.pricePerNight;
    }
    final days = checkOutDate!.difference(checkInDate!).inDays;
    return widget.hotel.pricePerNight * days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hotel.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.share), onPressed: () {}),
        ],
      ),
      body: BlocListener<HotelBloc, HotelState>(
        listener: (context, state) {
          if (state is HotelBookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Khách sạn đã được đặt thành công!'),
                backgroundColor: AppColors.primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is HotelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    widget.hotel.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 250,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.exclamationmark_triangle,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                        backgroundColor: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.hotel.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.star_fill,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location_solid,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.hotel.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.hotel.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: const Text('Wi-Fi Free'),
                          avatar: const Icon(CupertinoIcons.wifi, size: 18),
                          backgroundColor: Colors.grey.shade100,
                        ),
                        Chip(
                          label: const Text('Bể bơi'),
                          avatar: const Icon(CupertinoIcons.drop, size: 18),
                          backgroundColor: Colors.grey.shade100,
                        ),
                        Chip(
                          label: const Text('Bữa sáng'),
                          avatar: const Icon(CupertinoIcons.cart, size: 18),
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '\$${widget.hotel.pricePerNight}/đêm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.calendar,
                          color: Colors.grey,
                        ),
                        title: Text(
                          'Check-in: ${checkInDate != null ? DateFormat('dd MMM yyyy').format(checkInDate!) : 'Chọn ngày'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.forward,
                          color: Colors.grey,
                        ),
                        onTap: () => _selectCheckInDate(context),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.calendar,
                          color: Colors.grey,
                        ),
                        title: Text(
                          'Check-out: ${checkOutDate != null ? DateFormat('dd MMM yyyy').format(checkOutDate!) : 'Chọn ngày'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.forward,
                          color: Colors.grey,
                        ),
                        onTap: () => _selectCheckOutDate(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tổng giá: \$${NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 0).format(_calculateTotalPrice())}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FloatingActionButton.extended(
                      onPressed: () async {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        print('Current user ID before booking: $userId');
                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Vui lòng đăng nhập để đặt phòng',
                              ),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushNamed(context, AppRoutes.login);
                          return;
                        }
                        if (checkInDate == null || checkOutDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Vui lòng chọn ngày check-in và check-out',
                              ),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        final token =
                            await FirebaseAuth.instance.currentUser
                                ?.getIdToken();
                        print('Firebase ID token: $token');
                        final booking = HotelBooking(
                          id: const Uuid().v4(),
                          hotelId: widget.hotel.id,
                          userId: userId,
                          checkInDate: checkInDate!,
                          checkOutDate: checkOutDate!,
                          totalPrice: _calculateTotalPrice(),
                        );
                        context.read<HotelBloc>().add(BookHotel(booking));
                      },
                      label: const Text(
                        'Đặt Ngay',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      icon: const Icon(
                        CupertinoIcons.checkmark_alt,
                        color: Colors.white,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
