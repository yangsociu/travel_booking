import 'package:equatable/equatable.dart';

class FlightModel extends Equatable {
  final String id;
  final String documentId;
  final String departureCity;
  final String arrivalCity;
  final String departureCode;
  final String arrivalCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;

  const FlightModel({
    required this.id,
    required this.documentId,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureCode,
    required this.arrivalCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json, String documentId) {
    return FlightModel(
      id: (json['id'] as String?) ?? documentId, // Dùng documentId làm mặc định
      documentId: documentId,
      departureCity: (json['departureCity'] as String?) ?? 'Unknown',
      arrivalCity: (json['arrivalCity'] as String?) ?? 'Unknown',
      departureCode: (json['departureCode'] as String?) ?? 'Unknown',
      arrivalCode: (json['arrivalCode'] as String?) ?? 'Unknown',
      departureTime:
          json['departureTime'] != null
              ? DateTime.tryParse(json['arrivalTime'] as String? ?? '') ??
                  DateTime.now()
              : DateTime.now(),
      arrivalTime:
          json['arrivalTime'] != null
              ? DateTime.tryParse(json['arrivalTime'] as String? ?? '') ??
                  DateTime.now()
              : DateTime.now(),
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'departureCity': departureCity,
      'arrivalCity': arrivalCity,
      'departureCode': departureCode,
      'arrivalCode': arrivalCode,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price.toString(),
    };
  }

  @override
  List<Object> get props => [
    id,
    documentId,
    departureCity,
    arrivalCity,
    departureCode,
    arrivalCode,
    departureTime,
    arrivalTime,
    price,
  ];
}
