import 'package:booking_app/blocs/admin_flight/admin_flight_event.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_state.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_booking_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_bloc.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/services/ticket_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardScreenWrapper extends StatelessWidget {
  const AdminDashboardScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AdminFlightBloc(FlightService())..add(LoadFlights()),
        ),
        BlocProvider(
          create:
              (context) =>
                  AdminBookingBloc(TicketService())..add(LoadTickets()),
        ),
      ],
      child: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Quản lý vé',
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
            colors: [Color(0xFF1A1A2E), Color(0xFF2E2E4D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    title: Text(
                      'Bảng điều khiển Admin',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: AppColors.white,
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bảng điều khiển Admin',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Quản lý hệ thống đặt vé dễ dàng',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BlocBuilder<AdminBookingBloc, AdminBookingState>(
                        builder: (context, bookingState) {
                          final ticketCount =
                              bookingState is AdminBookingLoaded
                                  ? bookingState.tickets.length
                                  : 0;
                          return _buildStatCard(
                            context,
                            icon: Icons.confirmation_number,
                            title: 'Tổng Số Vé',
                            value: '$ticketCount',
                          );
                        },
                      ),
                      BlocBuilder<AdminFlightBloc, AdminFlightState>(
                        builder: (context, flightState) {
                          final flightCount =
                              flightState is AdminFlightLoaded
                                  ? flightState.flights.length
                                  : 0;
                          return _buildStatCard(
                            context,
                            icon: Icons.flight,
                            title: 'Tổng Số Flights',
                            value: '$flightCount',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: const Color(0xFF252545),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doanh Thu Theo Tháng',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 280,
                            child: BlocBuilder<
                              AdminBookingBloc,
                              AdminBookingState
                            >(
                              builder: (context, state) {
                                if (state is AdminBookingLoaded) {
                                  final monthlyRevenue =
                                      _calculateMonthlyRevenue(state.tickets);
                                  final maxY =
                                      monthlyRevenue.values.isNotEmpty
                                          ? monthlyRevenue.values.reduce(
                                                (a, b) => a > b ? a : b,
                                              ) *
                                              1.3
                                          : 1000000.0;
                                  return LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots:
                                              monthlyRevenue.entries
                                                  .map(
                                                    (e) => FlSpot(
                                                      e.key.toDouble(),
                                                      e.value,
                                                    ),
                                                  )
                                                  .toList(),
                                          isCurved: true,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryColor,
                                              AppColors.primaryColor
                                                  .withOpacity(0.6),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          barWidth: 4,
                                          dotData: FlDotData(
                                            show: true,
                                            getDotPainter:
                                                (spot, percent, bar, index) =>
                                                    FlDotCirclePainter(
                                                      radius: 6,
                                                      color: AppColors.white,
                                                      strokeWidth: 2,
                                                      strokeColor:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                          ),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primaryColor
                                                    .withOpacity(0.3),
                                                AppColors.primaryColor
                                                    .withOpacity(0.1),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                      ],
                                      minY: 0,
                                      maxY: maxY,
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 70,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                NumberFormat.compactCurrency(
                                                  locale: 'vi_VN',
                                                  symbol: '₫',
                                                  decimalDigits: 0,
                                                ).format(value),
                                                style: const TextStyle(
                                                  color: AppColors.grey,
                                                  fontSize: 12,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              const months = [
                                                'T1',
                                                'T2',
                                                'T3',
                                                'T4',
                                                'T5',
                                                'T6',
                                                'T7',
                                                'T8',
                                                'T9',
                                                'T10',
                                                'T11',
                                                'T12',
                                              ];
                                              final index = value.toInt();
                                              if (index >= 0 &&
                                                  index < months.length) {
                                                return Text(
                                                  months[index],
                                                  style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        horizontalInterval: maxY / 5,
                                        getDrawingHorizontalLine:
                                            (value) => FlLine(
                                              color: AppColors.grey.withOpacity(
                                                0.2,
                                              ),
                                              strokeWidth: 1,
                                            ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(
                                          color: AppColors.grey.withOpacity(
                                            0.3,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      lineTouchData: LineTouchData(
                                        enabled: true,
                                        touchTooltipData: LineTouchTooltipData(
                                          getTooltipItems:
                                              (touchedSpots) =>
                                                  touchedSpots
                                                      .map(
                                                        (
                                                          spot,
                                                        ) => LineTooltipItem(
                                                          NumberFormat.currency(
                                                            locale: 'vi_VN',
                                                            symbol: '₫',
                                                            decimalDigits: 0,
                                                          ).format(spot.y),
                                                          const TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.grey,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Icon(icon, size: 40, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  Map<int, double> _calculateMonthlyRevenue(List<Ticket> tickets) {
    final monthlyRevenue = <int, double>{};
    for (var ticket in tickets) {
      final month = ticket.bookingTime.month;
      monthlyRevenue[month] = (monthlyRevenue[month] ?? 0) + ticket.ticketPrice;
    }
    return monthlyRevenue;
  }
}
