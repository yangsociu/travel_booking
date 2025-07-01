// flight_model.dart
// models/flight_model.dart
// Model cho dữ liệu chuyến bay
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FlightModel extends Equatable {
  final String id; // Mã chuyến bay (VD: VN123)
  final String documentId; // documentID trong Firestore (VD: flight1)
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

  factory FlightModel.fromJson(Map<String, dynamic> json, String docId) {
    return FlightModel(
      id: json['id'] as String,
      documentId: docId,
      departureCity: json['departureCity'] as String,
      arrivalCity: json['arrivalCity'] as String,
      departureCode: json['departureCode'] as String,
      arrivalCode: json['arrivalCode'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      price: double.parse(json['price'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
