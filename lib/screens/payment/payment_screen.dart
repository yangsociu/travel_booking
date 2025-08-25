import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/models/discount_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/payment/payment_bloc.dart';
import 'package:booking_app/blocs/payment/payment_event.dart';
import 'package:booking_app/blocs/payment/payment_state.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/payment/payment_form.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class PaymentScreen extends StatefulWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;
  final String ticketPrice;
  final String duration;

  const PaymentScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
    required this.ticketPrice,
    required this.duration,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  String? _selectedDiscountCode;
  double _discountPercentage = 0.0;
  List<DiscountModel> _userDiscounts = [];

  @override
  void initState() {
    super.initState();
    _loadUserDiscounts();
  }

  Future<void> _loadUserDiscounts() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    if (userId.isNotEmpty) {
      try {
        final discounts = await context.read<FlightService>().getUserDiscounts(
          userId,
        );
        setState(() {
          _userDiscounts = discounts;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi tải mã giảm giá: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để xem mã giảm giá!')),
      );
    }
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var seat in widget.selectedSeats) {
      total +=
          int.parse(seat[0]) <= 4
              ? widget.flight.price * 1.5
              : widget.flight.price;
    }
    if (widget.returnFlight != null) {
      for (var seat in widget.returnSelectedSeats) {
        total +=
            int.parse(seat[0]) <= 4
                ? widget.returnFlight!.price * 1.5
                : widget.returnFlight!.price;
      }
    }
    return total * (1 - _discountPercentage / 100);
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(price);
  }

  String _calculateFlightDuration(DateTime departure, DateTime arrival) {
    final duration = arrival.difference(departure);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _applyDiscountCode(BuildContext context, String code) {
    if (code.isNotEmpty) {
      final discount = _userDiscounts.firstWhere(
        (d) =>
            d.code == code &&
            d.isActive &&
            (d.validUntil == null || d.validUntil!.isAfter(DateTime.now())),
        orElse:
            () => DiscountModel(
              code: '',
              discountPercentage: 0.0,
              validUntil: null,
              isActive: false,
              documentId: '', // Thêm documentId
            ),
      );
      if (discount.code.isNotEmpty && discount.documentId.isNotEmpty) {
        setState(() {
          _selectedDiscountCode = code;
          _discountPercentage = discount.discountPercentage;
        });
        context.read<HomeBloc>().add(SelectDiscount(code));
      } else {
        setState(() {
          _selectedDiscountCode = null;
          _discountPercentage = 0.0;
        });
        context.read<HomeBloc>().add(const SelectDiscount(''));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mã giảm giá không hợp lệ hoặc đã hết hạn!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn mã giảm giá!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final originalPrice =
            _calculateTotalPrice() / (1 - _discountPercentage / 100);

        return BlocProvider(
          create:
              (context) =>
                  PaymentBloc(flightService: context.read<FlightService>()),
          child: BlocListener<PaymentBloc, PaymentState>(
            listener: (context, state) async {
              if (state is PaymentSuccess) {
                final user = firebase_auth.FirebaseAuth.instance.currentUser;
                final userId = user?.uid ?? '';
                if (_selectedDiscountCode != null && userId.isNotEmpty) {
                  try {
                    final selectedDiscount = _userDiscounts.firstWhere(
                      (d) => d.code == _selectedDiscountCode,
                      orElse:
                          () => DiscountModel(
                            code: '',
                            discountPercentage: 0.0,
                            validUntil: null,
                            isActive: false,
                            documentId: '',
                          ),
                    );
                    if (selectedDiscount.documentId.isNotEmpty) {
                      await context.read<FlightService>().markDiscountAsUsed(
                        userId,
                        _selectedDiscountCode!,
                      );
                      await _loadUserDiscounts(); // Làm mới danh sách mã
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lỗi: Mã giảm giá không hợp lệ'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi đánh dấu mã giảm giá: $e'),
                      ),
                    );
                  }
                }
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.paymentSuccess,
                  arguments: {
                    'flight': widget.flight,
                    'passengers': widget.passengers,
                    'selectedSeats': widget.selectedSeats,
                    'returnFlight': widget.returnFlight,
                    'returnSelectedSeats': widget.returnSelectedSeats,
                    'totalPrice': _formatPrice(_calculateTotalPrice()),
                    'duration': _calculateFlightDuration(
                      widget.flight.departureTime,
                      widget.flight.arrivalTime,
                    ),
                    'discountPercentage': _discountPercentage,
                  },
                );
              } else if (state is PaymentError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.grey_2,
              appBar: AppBar(
                title: const Text(
                  'Thanh Toán',
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin vé',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TicketInfoWidget(
                      flight: widget.flight,
                      returnFlight: widget.returnFlight,
                      passengers: widget.passengers,
                      selectedSeats: widget.selectedSeats,
                      returnSelectedSeats: widget.returnSelectedSeats,
                      phoneNumber: widget.phoneNumber,
                      email: widget.email,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chi tiết thanh toán',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Giá gốc:',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatPrice(originalPrice),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (_selectedDiscountCode != null &&
                              _discountPercentage > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Giảm giá ($_selectedDiscountCode):',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '-${_formatPrice(originalPrice - _calculateTotalPrice())}',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng thanh toán:',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatPrice(_calculateTotalPrice()),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Mã giảm giá đã nhận',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _userDiscounts.isEmpty
                        ? const Text(
                          'Bạn chưa nhận mã giảm giá nào.',
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        )
                        : Column(
                          children:
                              _userDiscounts
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedDiscountCode =
                                              entry.value.code;
                                        });
                                        _applyDiscountCode(
                                          context,
                                          entry.value.code,
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color:
                                                _selectedDiscountCode ==
                                                        entry.value.code
                                                    ? AppColors.primaryColor
                                                    : AppColors.grey
                                                        .withOpacity(0.2),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.grey.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(2, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Mã: ${entry.value.code}',
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontFamily: 'Montserrat',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Giảm ${entry.value.discountPercentage}%',
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                    const SizedBox(height: 20),
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PaymentMethodTile(
                      icon: Icons.credit_card,
                      title: 'Thanh toán qua thẻ',
                      isSelected: _selectedPaymentMethod == 'Card',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Card';
                        });
                      },
                    ),
                    PaymentMethodTile(
                      icon: Icons.account_balance,
                      title: 'Chuyển khoản ngân hàng',
                      isSelected: _selectedPaymentMethod == 'Bank',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Bank';
                        });
                        context.read<PaymentBloc>().add(
                          StartPayment(
                            flight: widget.flight,
                            returnFlight: widget.returnFlight,
                            passengers: widget.passengers,
                            selectedSeats: widget.selectedSeats,
                            returnSelectedSeats: widget.returnSelectedSeats,
                            phoneNumber: widget.phoneNumber,
                            email: widget.email,
                            cardType: '',
                            cardNumber: '',
                            cardHolder: '',
                            expiryDate: '',
                            cvv: '',
                            discountPercentage: _discountPercentage,
                          ),
                        );
                      },
                    ),
                    PaymentMethodTile(
                      icon: Icons.account_balance_wallet,
                      title: 'Ví điện tử MoMo',
                      isSelected: _selectedPaymentMethod == 'MoMo',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'MoMo';
                        });
                        context.read<PaymentBloc>().add(
                          StartPayment(
                            flight: widget.flight,
                            returnFlight: widget.returnFlight,
                            passengers: widget.passengers,
                            selectedSeats: widget.selectedSeats,
                            returnSelectedSeats: widget.returnSelectedSeats,
                            phoneNumber: widget.phoneNumber,
                            email: widget.email,
                            cardType: '',
                            cardNumber: '',
                            cardHolder: '',
                            expiryDate: '',
                            cvv: '',
                            discountPercentage: _discountPercentage,
                          ),
                        );
                      },
                    ),
                    if (_selectedPaymentMethod == 'Card') ...[
                      const SizedBox(height: 20),
                      PaymentForm(
                        flight: widget.flight,
                        returnFlight: widget.returnFlight,
                        passengers: widget.passengers,
                        selectedSeats: widget.selectedSeats,
                        returnSelectedSeats: widget.returnSelectedSeats,
                        phoneNumber: widget.phoneNumber,
                        email: widget.email,
                        discountPercentage: _discountPercentage,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TicketInfoWidget extends StatelessWidget {
  final FlightModel flight;
  final FlightModel? returnFlight;
  final List<Passenger> passengers;
  final List<String> selectedSeats;
  final List<String> returnSelectedSeats;
  final String phoneNumber;
  final String email;

  const TicketInfoWidget({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.selectedSeats,
    required this.returnSelectedSeats,
    required this.phoneNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final departureTime = timeFormat.format(flight.departureTime);
    final arrivalTime = timeFormat.format(flight.arrivalTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.flight_takeoff,
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${flight.departureCity} (${flight.departureAirportName})',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.departureAirportCode,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      departureTime,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.flight,
                size: 24,
                color: AppColors.primaryColor.withOpacity(0.7),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${flight.arrivalCity} (${flight.arrivalAirportName})',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.flight_land,
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.arrivalAirportCode,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      arrivalTime,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (returnFlight != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${returnFlight!.departureCity} (${returnFlight!.departureAirportName})',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        returnFlight!.departureAirportCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeFormat.format(returnFlight!.departureTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.flight,
                  size: 24,
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${returnFlight!.arrivalCity} (${returnFlight!.arrivalAirportName})',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.flight_land,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        returnFlight!.arrivalAirportCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeFormat.format(returnFlight!.arrivalTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Hành khách & ghế:',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              passengers.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${passengers[index].fullName}: Ghế ${selectedSeats[index]}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (returnFlight != null &&
                      index < returnSelectedSeats.length)
                    Text(
                      'Chuyến về: Ghế ${returnSelectedSeats[index]}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Liên hệ: $phoneNumber',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Email: $email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
