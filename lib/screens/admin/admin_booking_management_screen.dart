import 'package:booking_app/models/ticket.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_booking_bloc.dart';
import 'package:booking_app/services/ticket_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/admin/ticket_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminBookingManagementScreenWrapper extends StatelessWidget {
  const AdminBookingManagementScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('Creating AdminBookingBloc in AdminBookingManagementScreenWrapper');
    return BlocProvider(
      create:
          (context) => AdminBookingBloc(TicketService())..add(LoadTickets()),
      child: const AdminBookingManagementScreen(),
    );
  }
}

class AdminBookingManagementScreen extends StatelessWidget {
  const AdminBookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBookingBloc, AdminBookingState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is AdminBookingError) {
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
        } else if (state is AdminBookingLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E1E1E),
              content: Text(
                'Cập nhật danh sách vé thành công',
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
              colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Quản lý vé đặt',
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
                    child: BlocBuilder<AdminBookingBloc, AdminBookingState>(
                      builder: (context, state) {
                        print('BlocBuilder received state: $state');
                        if (state is AdminBookingLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is AdminBookingLoaded) {
                          final groupedTickets = <String, List<Ticket>>{};
                          for (var ticket in state.tickets) {
                            final key = '${ticket.phoneNumber}_${ticket.email}';
                            groupedTickets
                                .putIfAbsent(key, () => [])
                                .add(ticket);
                          }
                          return groupedTickets.isEmpty
                              ? Center(
                                child: Text(
                                  'Không có vé nào.',
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
                                  print('Refreshing ticket list');
                                  context.read<AdminBookingBloc>().add(
                                    LoadTickets(),
                                  );
                                },
                                child: ListView.builder(
                                  itemCount: groupedTickets.length,
                                  itemBuilder: (context, index) {
                                    final key = groupedTickets.keys.elementAt(
                                      index,
                                    );
                                    final tickets = groupedTickets[key]!;
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
                                            'Đặt chỗ: ${tickets.first.phoneNumber} / ${tickets.first.email}',
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
                                          ...tickets.map(
                                            (ticket) => TicketListItem(
                                              ticket: ticket,
                                              onDelete: () async {
                                                print(
                                                  'Attempting to delete ticket: ${ticket.id}',
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
                                                          'Bạn có chắc chắn muốn xóa vé này?',
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
                                                  context
                                                      .read<AdminBookingBloc>()
                                                      .add(
                                                        DeleteTicket(
                                                          ticket.documentId,
                                                        ),
                                                      );
                                                  context
                                                      .read<AdminBookingBloc>()
                                                      .add(LoadTickets());
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          const Color(
                                                            0xFF1E1E1E,
                                                          ),
                                                      content: Text(
                                                        'Xóa vé thành công',
                                                        style: Theme.of(context)
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
                        } else if (state is AdminBookingError) {
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
