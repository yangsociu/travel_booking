import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_discount_bloc.dart';
import 'package:booking_app/blocs/admin_flight/admin_discount_event.dart';
import 'package:booking_app/models/discount_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class DiscountListItem extends StatelessWidget {
  final DiscountModel discount;
  final VoidCallback onDelete;

  const DiscountListItem({
    super.key,
    required this.discount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Mã: ${discount.code}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    if (discount.documentId.isEmpty) {
                      print(
                        'Error: Empty documentId for discount: ${discount.code}',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Lỗi: Không tìm thấy ID mã giảm giá',
                          ),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                      return;
                    }
                    showDialog<bool>(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            backgroundColor: const Color(0xFF1E1E1E),
                            title: Text(
                              'Xác nhận xóa',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            content: Text(
                              'Bạn có chắc muốn xóa mã "${discount.code}"?',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: AppColors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.pop(dialogContext, false),
                                child: Text(
                                  'Hủy',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.grey,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  print(
                                    'Calling onDelete for discount: ${discount.code}, documentId: ${discount.documentId}',
                                  );
                                  print('BlocProvider context: $context');
                                  BlocProvider.of<AdminDiscountBloc>(
                                    context,
                                  ).add(DeleteDiscount(discount.documentId));
                                  Navigator.pop(dialogContext, true);
                                },
                                child: Text(
                                  'Xóa',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Phần trăm giảm: ${discount.discountPercentage}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              discount.validUntil != null
                  ? 'Hết hạn: ${dateFormat.format(discount.validUntil!)}'
                  : 'Hết hạn: Không thời hạn',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Trạng thái: ${discount.isActive ? 'Hoạt động' : 'Không hoạt động'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color:
                    discount.isActive ? AppColors.primaryColor : AppColors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
