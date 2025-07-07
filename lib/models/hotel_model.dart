import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double pricePerNight;
  final String location;

  HotelModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.pricePerNight,
    required this.location,
  });

  factory HotelModel.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception('Hotel document not found');
    }
    final data = doc.data() as Map<String, dynamic>;
    final imageUrl = data['imageUrl'] ?? '';
    print('Loading image for hotel ${doc.id}: $imageUrl');
    return HotelModel(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: imageUrl,
      description: data['description'] ?? '',
      pricePerNight:
          double.tryParse(data['pricePerNight']?.toString() ?? '0.0') ?? 0.0,
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'pricePerNight': pricePerNight,
      'location': location,
    };
  }
}

class HotelBooking {
  final String id;
  final String hotelId;
  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;

  HotelBooking({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
  });

  factory HotelBooking.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists || doc.data() == null) {
      throw Exception('Hotel document not found');
    }
    final data = doc.data() as Map<String, dynamic>;
    return HotelBooking(
      id: doc.id,
      hotelId: data['hotelId'] ?? '',
      userId: data['userId'] ?? '',
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      totalPrice:
          double.tryParse(data['totalPrice']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    final data = {
      'hotelId': hotelId,
      'userId': userId.trim(),
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'totalPrice': totalPrice,
    };
    print(
      'Booking data type check: userId type=${userId.runtimeType}, value="$userId", length=${userId.length}',
    );
    return data;
  }
}
