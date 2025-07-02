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
    print('Building AdminBookingManagementScreen');
    return BlocListener<AdminBookingBloc, AdminBookingState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is AdminBookingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
        } else if (state is AdminBookingLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật danh sách vé thành công')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: AppBar(
          title: Text(
            'Quản lý vé đặt',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.grey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () {
              print('Navigating back from AdminBookingManagementScreen');
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.flight, color: AppColors.black),
              tooltip: 'Quản lý chuyến bay',
              onPressed: () {
                print('Navigating to AdminFlightManagementScreen');
                Navigator.pushNamed(context, AppRoutes.adminFlightManagement);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.black),
              tooltip: 'Đăng xuất',
              onPressed: () async {
                print('Logging out from AdminBookingManagementScreen');
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<AdminBookingBloc, AdminBookingState>(
          builder: (context, state) {
            print('BlocBuilder received state: $state');
            if (state is AdminBookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminBookingLoaded) {
              // Nhóm vé theo phoneNumber hoặc email để nhận diện khứ hồi
              final groupedTickets = <String, List<Ticket>>{};
              for (var ticket in state.tickets) {
                final key = '${ticket.phoneNumber}_${ticket.email}';
                groupedTickets.putIfAbsent(key, () => []).add(ticket);
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    state.tickets.isEmpty
                        ? Center(
                          child: Text(
                            'Không có vé nào.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () async {
                            print('Refreshing ticket list');
                            context.read<AdminBookingBloc>().add(LoadTickets());
                          },
                          child: ListView.builder(
                            itemCount: groupedTickets.length,
                            itemBuilder: (context, index) {
                              final key = groupedTickets.keys.elementAt(index);
                              final tickets = groupedTickets[key]!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      'Đặt chỗ: ${tickets.first.phoneNumber} / ${tickets.first.email}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  ...tickets.map(
                                    (ticket) => TicketListItem(
                                      ticket: ticket,
                                      onDelete: () async {
                                        print(
                                          'Attempting to delete ticket: ${ticket.id}',
                                        );
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (dialogContext) => AlertDialog(
                                                title: const Text(
                                                  'Xác nhận xóa',
                                                ),
                                                content: const Text(
                                                  'Bạn có chắc chắn muốn xóa vé này?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          dialogContext,
                                                        ).pop(false),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          dialogContext,
                                                        ).pop(true),
                                                    child: const Text(
                                                      'Xóa',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirm == true) {
                                          context.read<AdminBookingBloc>().add(
                                            DeleteTicket(ticket.documentId),
                                          );
                                          context.read<AdminBookingBloc>().add(
                                            LoadTickets(),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Xóa vé thành công',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
              );
            } else if (state is AdminBookingError) {
              return Center(
                child: Text(
                  'Lỗi: ${state.message}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                'Khởi tạo...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
