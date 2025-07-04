import 'package:equatable/equatable.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';

class Ticket extends Equatable {
  final String id; // Document ID trong Firestore
  final String documentId;
  final FlightModel flight;
  final Passenger passenger;
  final String seat;
  final double ticketPrice;
  final DateTime bookingTime;
  final String phoneNumber; // Thêm để nhận diện vé khứ hồi
  final String email; // Thêm để nhận diện vé khứ hồi
  final bool isUsed; // Thêm trường isUsed

  const Ticket({
    required this.id,
    required this.documentId,
    required this.flight,
    required this.passenger,
    required this.seat,
    required this.ticketPrice,
    required this.bookingTime,
    required this.phoneNumber,
    required this.email,
    this.isUsed = false, // Mặc định là chưa sử dụng
  });

  factory Ticket.fromJson(Map<String, dynamic> json, String docId) {
    print('Parsing ticket for document: $docId');
    return Ticket(
      id: docId,
      documentId: docId,
      flight: FlightModel.fromJson(
        json['flight'] as Map<String, dynamic>? ?? {},
        json['flight']?['id'] as String? ?? docId,
      ),
      passenger: Passenger.fromJson(
        json['passenger'] as Map<String, dynamic>? ?? {},
      ),
      seat: json['seat'] as String? ?? 'Unknown',
      ticketPrice:
          double.tryParse(json['ticketPrice']?.toString() ?? '0.0') ?? 0.0,
      bookingTime:
          DateTime.tryParse(json['bookingTime'] as String? ?? '') ??
          DateTime.now(),
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isUsed: json['isUsed'] ?? false, // Lấy giá trị isUsed từ JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight': flight.toJson(),
      'passenger': passenger.toJson(),
      'seat': seat,
      'ticketPrice': ticketPrice.toString(),
      'bookingTime': bookingTime.toIso8601String(),
      'phoneNumber': phoneNumber,
      'email': email,
      'isUsed': isUsed, // Thêm isUsed vào JSON
    };
  }

  @override
  List<Object?> get props => [
    id,
    documentId,
    flight,
    passenger,
    seat,
    ticketPrice,
    bookingTime,
    phoneNumber,
    email,
    isUsed,
  ];
}
