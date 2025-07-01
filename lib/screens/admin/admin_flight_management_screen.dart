// admin_flight_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_event.dart';
import 'package:booking_app/blocs/admin_flight/admin_flight_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/admin/flight_form.dart';
import 'package:booking_app/widgets/admin/flight_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminFlightManagementScreenWrapper extends StatelessWidget {
  const AdminFlightManagementScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('Initializing AdminFlightManagementScreenWrapper with BlocProvider');
    return BlocProvider(
      create: (context) => AdminFlightBloc(FlightService())..add(LoadFlights()),
      child: const AdminFlightManagementScreen(),
    );
  }
}

class AdminFlightManagementScreen extends StatelessWidget {
  const AdminFlightManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building AdminFlightManagementScreen');
    return BlocListener<AdminFlightBloc, AdminFlightState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is AdminFlightError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
        } else if (state is AdminFlightLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật danh sách chuyến bay thành công'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: AppBar(
          title: Text(
            'Quản lý chuyến bay',
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
              print('Navigating back from AdminFlightManagementScreen');
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.black),
              onPressed: () {
                print('Opening FlightForm for adding new flight');
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (modalContext) => BlocProvider.value(
                        value: context.read<AdminFlightBloc>(),
                        child: const FlightForm(),
                      ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.black),
              tooltip: 'Đăng xuất',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login', // hoặc AppRoutes.login nếu bạn dùng hằng số
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<AdminFlightBloc, AdminFlightState>(
          builder: (context, state) {
            print('BlocBuilder received state: $state');
            if (state is AdminFlightLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminFlightLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    state.flights.isEmpty
                        ? Center(
                          child: Text(
                            'Không có chuyến bay nào.',
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
                            context.read<AdminFlightBloc>().add(LoadFlights());
                          },
                          child: ListView.builder(
                            itemCount: state.flights.length,
                            itemBuilder: (context, index) {
                              return FlightListItem(
                                flight: state.flights[index],
                                onEdit: () {
                                  print(
                                    'Opening FlightForm for editing flight: ${state.flights[index].id}',
                                  );
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:
                                        (modalContext) => BlocProvider.value(
                                          value:
                                              context.read<AdminFlightBloc>(),
                                          child: FlightForm(
                                            flight: state.flights[index],
                                          ),
                                        ),
                                  );
                                },
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (dialogContext) => AlertDialog(
                                          title: const Text('Xác nhận xóa'),
                                          content: const Text(
                                            'Bạn có chắc chắn muốn xóa chuyến bay này?',
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
                                    context.read<AdminFlightBloc>().add(
                                      DeleteFlight(
                                        state.flights[index].documentId,
                                      ),
                                    );
                                    // Gọi lại LoadFlights để cập nhật UI
                                    context.read<AdminFlightBloc>().add(
                                      LoadFlights(),
                                    );
                                    // Hiển thị thông báo xóa thành công
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Xóa chuyến bay thành công',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
              );
            } else if (state is AdminFlightError) {
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
