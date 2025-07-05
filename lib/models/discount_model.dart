import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DiscountModel extends Equatable {
  final String code;
  final double discountPercentage;
  final DateTime? validUntil; // Thay đổi thành nullable
  final bool isActive;
  final String documentId;

  const DiscountModel({
    required this.code,
    required this.discountPercentage,
    this.validUntil, // Xóa required
    required this.isActive,
    this.documentId = '',
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json, String documentId) {
    return DiscountModel(
      code: json['code'] as String? ?? documentId,
      discountPercentage:
          double.tryParse(json['discountPercentage']?.toString() ?? '0.0') ??
          0.0,
      validUntil:
          json['validUntil'] != null
              ? (json['validUntil'] is Timestamp
                  ? (json['validUntil'] as Timestamp).toDate()
                  : DateTime.parse(json['validUntil'] as String))
              : null, // Hỗ trợ null
      isActive: json['isActive'] as bool? ?? false,
      documentId: json['documentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountPercentage': discountPercentage,
      'validUntil': validUntil != null ? Timestamp.fromDate(validUntil!) : null,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [code, discountPercentage, validUntil, isActive];
}
