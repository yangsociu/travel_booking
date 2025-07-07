import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_discount_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_discount_event.dart';
import 'package:booking_app/blocs/admin_flight/admin_discount_state.dart';
import 'package:booking_app/models/discount_model.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/admin/discount_list_item.dart';

class AddDiscountScreenWrapper extends StatelessWidget {
  const AddDiscountScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final flightService = context.read<FlightService>();
    print('FlightService provided: $flightService');
    final adminDiscountBloc = AdminDiscountBloc(flightService);
    print('AdminDiscountBloc created: $adminDiscountBloc');
    return BlocProvider(
      create: (context) => adminDiscountBloc..add(LoadDiscounts()),
      child: const AddDiscountScreen(),
    );
  }
}

class AddDiscountScreen extends StatefulWidget {
  const AddDiscountScreen({super.key});

  @override
  _AddDiscountScreenState createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  bool? _isAdmin;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final adminDoc =
          await FirebaseFirestore.instance
              .collection('admins')
              .doc(user.uid)
              .get();
      setState(() {
        _isAdmin = adminDoc.exists && adminDoc.data()?['role'] == 'admin';
      });
    } else {
      setState(() {
        _isAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: const Color(0xFF1E1E1E),
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (modalContext) => BlocProvider.value(
                    value: BlocProvider.of<AdminDiscountBloc>(context),
                    child: DiscountForm(
                      flightService: context.read<FlightService>(),
                    ),
                  ),
            );
          },
          child: const Icon(Icons.add, color: AppColors.white),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Quản lý mã giảm giá',
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
                    child:
                        _isAdmin == null
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                            : _isAdmin == false
                            ? Center(
                              child: Text(
                                'Bạn không có quyền truy cập. Vui lòng đăng nhập bằng tài khoản admin.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                            : BlocListener<
                              AdminDiscountBloc,
                              AdminDiscountState
                            >(
                              listener: (context, state) {
                                print('BlocListener received state: $state');
                                if (state is DeleteDiscountSuccess) {
                                  print(
                                    'Discount deleted, showing success SnackBar',
                                  );
                                  _scaffoldMessengerKey.currentState?.showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF1E1E1E),
                                      content: Text(
                                        'Xóa mã giảm giá thành công',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      duration: const Duration(seconds: 4),
                                      onVisible: () {
                                        print(
                                          'SnackBar visible, loading discounts',
                                        );
                                        BlocProvider.of<AdminDiscountBloc>(
                                          context,
                                        ).add(LoadDiscounts());
                                      },
                                    ),
                                  );
                                } else if (state is DeleteDiscountFailure) {
                                  print(
                                    'Delete discount failed: ${state.message}',
                                  );
                                  _scaffoldMessengerKey.currentState?.showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        'Lỗi khi xóa mã giảm giá: ${state.message}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      duration: const Duration(seconds: 4),
                                    ),
                                  );
                                } else if (state is AdminDiscountError) {
                                  print(
                                    'Error in BlocListener: ${state.message}',
                                  );
                                  _scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                            'Lỗi: ${state.message}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              color: AppColors.white,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );
                                }
                              },
                              child: BlocBuilder<
                                AdminDiscountBloc,
                                AdminDiscountState
                              >(
                                builder: (context, state) {
                                  print('BlocBuilder rendering state: $state');
                                  if (state is AdminDiscountLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    );
                                  } else if (state is AdminDiscountLoaded) {
                                    return state.discounts.isEmpty
                                        ? Center(
                                          child: Text(
                                            'Không có mã giảm giá nào.',
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
                                            print('Refreshing discount list');
                                            BlocProvider.of<AdminDiscountBloc>(
                                              context,
                                            ).add(LoadDiscounts());
                                          },
                                          child: ListView.builder(
                                            itemCount: state.discounts.length,
                                            itemBuilder: (context, index) {
                                              final discount =
                                                  state.discounts[index];
                                              return Dismissible(
                                                key: Key(discount.documentId),
                                                direction:
                                                    DismissDirection.endToStart,
                                                background: Container(
                                                  color: Colors.redAccent,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16.0,
                                                      ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                                confirmDismiss: (
                                                  direction,
                                                ) async {
                                                  if (discount
                                                      .documentId
                                                      .isEmpty) {
                                                    print(
                                                      'Empty documentId for discount: ${discount.code}',
                                                    );
                                                    _scaffoldMessengerKey
                                                        .currentState
                                                        ?.showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Color(
                                                                  0xFF1E1E1E,
                                                                ),
                                                            content: Text(
                                                              'Lỗi: Không tìm thấy ID mã giảm giá',
                                                              style: TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                            ),
                                                            duration: Duration(
                                                              seconds: 4,
                                                            ),
                                                          ),
                                                        );
                                                    return false;
                                                  }
                                                  return showDialog<bool>(
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
                                                            'Bạn có chắc muốn xóa mã "${discount.code}"?',
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
                                                              onPressed: () {
                                                                print(
                                                                  'Triggering DeleteDiscount for: ${discount.code}, documentId: ${discount.documentId}',
                                                                );
                                                                BlocProvider.of<
                                                                  AdminDiscountBloc
                                                                >(context).add(
                                                                  DeleteDiscount(
                                                                    discount
                                                                        .documentId,
                                                                  ),
                                                                );
                                                                Navigator.of(
                                                                  dialogContext,
                                                                ).pop(true);
                                                              },
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
                                                },
                                                onDismissed: (direction) {
                                                  // Không cần thực hiện vì đã xử lý trong confirmDismiss
                                                },
                                                child: DiscountListItem(
                                                  discount: discount,
                                                  onDelete: () {
                                                    if (discount
                                                        .documentId
                                                        .isEmpty) {
                                                      print(
                                                        'Empty documentId for discount: ${discount.code}',
                                                      );
                                                      _scaffoldMessengerKey
                                                          .currentState
                                                          ?.showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Color(
                                                                    0xFF1E1E1E,
                                                                  ),
                                                              content: Text(
                                                                'Lỗi: Không tìm thấy ID mã giảm giá',
                                                                style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                ),
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                    seconds: 4,
                                                                  ),
                                                            ),
                                                          );
                                                      return;
                                                    }
                                                    showDialog<bool>(
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
                                                              'Bạn có chắc muốn xóa mã "${discount.code}"?',
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
                                                                    ).pop(
                                                                      false,
                                                                    ),
                                                                child: Text(
                                                                  'Hủy',
                                                                  style: Theme.of(
                                                                        context,
                                                                      )
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
                                                                onPressed: () {
                                                                  print(
                                                                    'Triggering DeleteDiscount for: ${discount.code}, documentId: ${discount.documentId}',
                                                                  );
                                                                  BlocProvider.of<
                                                                    AdminDiscountBloc
                                                                  >(
                                                                    context,
                                                                  ).add(
                                                                    DeleteDiscount(
                                                                      discount
                                                                          .documentId,
                                                                    ),
                                                                  );
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop(true);
                                                                },
                                                                child: Text(
                                                                  'Xóa',
                                                                  style: Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                        color:
                                                                            Colors.redAccent,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                  } else if (state is AdminDiscountError) {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscountForm extends StatefulWidget {
  final FlightService flightService;

  const DiscountForm({super.key, required this.flightService});

  @override
  _DiscountFormState createState() => _DiscountFormState();
}

class _DiscountFormState extends State<DiscountForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _percentageController = TextEditingController();
  DateTime? _validUntil;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thêm mã giảm giá',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Mã giảm giá',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Vui lòng nhập mã' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _percentageController,
                  decoration: InputDecoration(
                    labelText: 'Phần trăm giảm giá',
                    labelStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Montserrat',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    fillColor: const Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Montserrat',
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Vui lòng nhập phần trăm' : null,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(
                    _validUntil == null
                        ? 'Chọn ngày hết hạn (không bắt buộc)'
                        : 'Hết hạn: ${_validUntil!.toString().substring(0, 10)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _validUntil = selectedDate;
                      });
                    }
                  },
                  tileColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                    : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          try {
                            final discount = DiscountModel(
                              code: _codeController.text.trim(),
                              discountPercentage: double.parse(
                                _percentageController.text,
                              ),
                              validUntil: _validUntil,
                              isActive: true,
                              documentId: '',
                            );
                            print(
                              'Adding discount: ${discount.code}, documentId: auto-generated',
                            );
                            await widget.flightService.addDiscount(discount);
                            BlocProvider.of<AdminDiscountBloc>(
                              context,
                            ).add(LoadDiscounts());
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() {
                              _errorMessage = 'Lỗi khi thêm mã giảm giá: $e';
                            });
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        } else {
                          setState(() {
                            _errorMessage =
                                'Vui lòng điền đầy đủ thông tin bắt buộc';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thêm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
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
