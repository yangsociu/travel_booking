import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/widgets/admin/bottom_navigation_widget.dart';
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
    return BlocListener<AdminFlightBloc, AdminFlightState>(
      listener: (context, state) {
        print('BlocListener received state: $state');
        if (state is AdminFlightError) {
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
        } else if (state is AdminFlightLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1E1E1E),
              content: Text(
                'Cập nhật danh sách chuyến bay thành công',
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            print('Opening FlightForm for adding new flight');
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (modalContext) => BlocProvider.value(
                    value: context.read<AdminFlightBloc>(),
                    child: const FlightForm(),
                  ),
            );
          },
          child: const Icon(Icons.add, color: AppColors.white),
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
                    'Quản lý chuyến bay',
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<AdminFlightBloc, AdminFlightState>(
                      builder: (context, state) {
                        print('BlocBuilder received state: $state');
                        if (state is AdminFlightLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else if (state is AdminFlightLoaded) {
                          return state.flights.isEmpty
                              ? Center(
                                child: Text(
                                  'Không có chuyến bay nào.',
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
                                  context.read<AdminFlightBloc>().add(
                                    LoadFlights(),
                                  );
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
                                          backgroundColor: Colors.transparent,
                                          builder:
                                              (modalContext) =>
                                                  BlocProvider.value(
                                                    value:
                                                        context
                                                            .read<
                                                              AdminFlightBloc
                                                            >(),
                                                    child: FlightForm(
                                                      flight:
                                                          state.flights[index],
                                                    ),
                                                  ),
                                        );
                                      },
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (dialogContext) => AlertDialog(
                                                backgroundColor: const Color(
                                                  0xFF1E1E1E,
                                                ),
                                                title: Text(
                                                  'Xác nhận xóa',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: AppColors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                ),
                                                content: Text(
                                                  'Bạn có chắc chắn muốn xóa chuyến bay này?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: AppColors.white,
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color:
                                                                AppColors.grey,
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
                                                      style: Theme.of(context)
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
                                          context.read<AdminFlightBloc>().add(
                                            DeleteFlight(
                                              state.flights[index].documentId,
                                            ),
                                          );
                                          context.read<AdminFlightBloc>().add(
                                            LoadFlights(),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: const Color(
                                                0xFF1E1E1E,
                                              ),
                                              content: Text(
                                                'Xóa chuyến bay thành công',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors.white,
                                                      fontFamily: 'Montserrat',
                                                    ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                        } else if (state is AdminFlightError) {
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
        bottomNavigationBar: const BottomNavigationWidget(
          currentIndex: 1,
        ), // Chuyến bay\
      ),
    );
  }
}
