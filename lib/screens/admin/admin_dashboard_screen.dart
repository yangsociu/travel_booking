import 'package:booking_app/blocs/admin_flight/admin_flight_event.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_state.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/widgets/admin/bottom_navigation_widget.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const Icon(
                    Icons.dashboard,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bảng Điều Khiển Admin',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quản lý chuyến bay và vé đặt một cách dễ dàng',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
                            icon: Icons.airplane_ticket,
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
                            title: 'Tổng Số Flight',
                            value: '$flightCount',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doanh Thu Theo Tháng',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250,
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
                                              1.2
                                          : 1000000.0;
                                  return BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: maxY,
                                      minY: 0,
                                      barGroups:
                                          monthlyRevenue.entries
                                              .toList()
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry) => BarChartGroupData(
                                                  x: entry.key,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: entry.value.value,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppColors
                                                              .primaryColor,
                                                          AppColors.primaryColor
                                                              .withOpacity(0.7),
                                                        ],
                                                        begin:
                                                            Alignment
                                                                .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                      ),
                                                      width: 16,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 60,
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
                                              return Text(
                                                months[value.toInt()],
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              );
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
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        touchTooltipData: BarTouchTooltipData(
                                          getTooltipItem: (
                                            group,
                                            groupIndex,
                                            rod,
                                            rodIndex,
                                          ) {
                                            return BarTooltipItem(
                                              NumberFormat.currency(
                                                locale: 'vi_VN',
                                                symbol: '₫',
                                                decimalDigits: 0,
                                              ).format(rod.toY),
                                              const TextStyle(
                                                color: AppColors.white,
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                              ),
                                            );
                                          },
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
      bottomNavigationBar: const BottomNavigationWidget(
        currentIndex: 0,
      ), // Home
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
