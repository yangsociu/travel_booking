import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/home/home_bloc.dart';
import 'package:booking_app/blocs/home/home_event.dart';
import 'package:booking_app/blocs/home/home_state.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:booking_app/widgets/common/custom_button.dart';
import 'package:booking_app/widgets/home/custom_bottom_navigation.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final FlightService flightService;

  const ProfileScreen({super.key, required this.flightService});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.email}, UID: ${user?.uid}');
    if (user != null) {
      user.getIdToken(true).then((token) => print('Refreshed token: $token'));
    } else {
      print('No user logged in, redirecting to login');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      });
    }
    final userEmail = user?.email ?? '';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FC3F7), Color(0xFFB2EBF2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hồ sơ cá nhân',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thông tin tài khoản của bạn',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 16, color: AppColors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.1,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FutureBuilder<DocumentSnapshot>(
                          future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text(
                                'Lỗi khi tải thông tin: ${snapshot.error}',
                              );
                            }
                            final data =
                                snapshot.data?.data() as Map<String, dynamic>?;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  data?['fullName']?.isNotEmpty == true
                                      ? data!['fullName']
                                      : 'Chưa cập nhật',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                    fontFamily: 'Montserrat',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  'Email',
                                  data?['email'] ?? userEmail,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Ngày sinh', data?['birthDate']),
                                _buildInfoRow(
                                  'Số điện thoại',
                                  data?['phoneNumber'],
                                ),
                                _buildInfoRow('Giới tính', data?['gender']),
                                _buildInfoRow('Địa chỉ', data?['address']),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder:
                                  (context) =>
                                      UpdateInfoDialog(userUid: user?.uid),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cập nhật thông tin'),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Đăng xuất',
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.login,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.dateSelection);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.ticketHistory);
              break;
            case 3:
              // Đã ở ProfileScreen
              break;
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text('$label:')),
          Expanded(
            child: Text(value?.isNotEmpty == true ? value! : 'Chưa cập nhật'),
          ),
        ],
      ),
    );
  }
}

class UpdateInfoDialog extends StatefulWidget {
  final String? userUid;
  const UpdateInfoDialog({Key? key, required this.userUid}) : super(key: key);

  @override
  State<UpdateInfoDialog> createState() => _UpdateInfoDialogState();
}

class _UpdateInfoDialogState extends State<UpdateInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật thông tin cá nhân'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _birthDateController.text = picked
                        .toIso8601String()
                        .substring(0, 10);
                    setState(() {});
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày sinh (YYYY-MM-DD)',
                    ),
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Không được để trống'
                                : null,
                  ),
                ),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Không được để trống';
                  final phoneReg = RegExp(r'^[0-9]{9,12}$');
                  if (!phoneReg.hasMatch(v))
                    return 'Số điện thoại không hợp lệ';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender.isNotEmpty ? _gender : null,
                items: const [
                  DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                  DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                  DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? ''),
                decoration: const InputDecoration(labelText: 'Giới tính'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Chọn giới tính' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && widget.userUid != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userUid)
                  .set({
                    'fullName': _fullNameController.text,
                    'birthDate': _birthDateController.text,
                    'phoneNumber': _phoneController.text,
                    'gender': _gender,
                    'address': _addressController.text,
                  }, SetOptions(merge: true));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cập nhật thành công!')),
              );
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
