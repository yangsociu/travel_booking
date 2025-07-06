import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/models/airline_model.dart';
import 'package:booking_app/models/destination_model.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/flight_search_model.dart';
import 'package:booking_app/models/discount_model.dart';

class City {
  final String name;
  final String airportName;
  final String airportCode;

  City({
    required this.name,
    required this.airportName,
    required this.airportCode,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      airportName: json['airportName'] as String,
      airportCode: json['airportCode'] as String,
    );
  }
}

class FlightService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> getCities() async {
    try {
      final snapshot = await _firestore.collection('cities').get();
      final cities =
          snapshot.docs.map((doc) {
            final data = doc.data();
            print('Document data: $data');
            return {
              'name': data['name'] as String,
              'airportName': data['airportName'] as String,
              'airportCode': data['airportCode'] as String,
            };
          }).toList();
      print('Firestore cities fetched: ${cities.length} documents');
      return cities;
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  Future<List<AirlineModel>> getAirlines() async {
    try {
      final snapshot = await _firestore.collection('airlines').get();
      final seenIds = <String>{};
      final airlines = <AirlineModel>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Airline document data: $data');
        final airline = AirlineModel.fromJson(data);
        if (!seenIds.contains(airline.id)) {
          seenIds.add(airline.id);
          airlines.add(airline);
        } else {
          print('Duplicate airline ID detected: ${airline.id}, skipping...');
        }
      }
      print('Airlines fetched: ${airlines.map((a) => a.name).toList()}');
      return airlines;
    } catch (e) {
      print('Error fetching airlines: $e');
      return [];
    }
  }

  Future<List<DestinationModel>> getDestinations() async {
    try {
      final snapshot = await _firestore.collection('destinations').get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách điểm đến: $e');
    }
  }

  Future<List<FlightModel>> getFlights({
    required String departureCity,
    required String arrivalCity,
    required DateTime departureDate,
  }) async {
    try {
      final startOfDay =
          DateTime(
            departureDate.year,
            departureDate.month,
            departureDate.day,
          ).toIso8601String();
      final endOfDay =
          DateTime(
            departureDate.year,
            departureDate.month,
            departureDate.day,
            23,
            59,
            59,
          ).toIso8601String();
      final snapshot =
          await _firestore
              .collection('flights')
              .where('departureCity', isEqualTo: departureCity)
              .where('arrivalCity', isEqualTo: arrivalCity)
              .where('departureTime', isGreaterThanOrEqualTo: startOfDay)
              .where('departureTime', isLessThanOrEqualTo: endOfDay)
              .orderBy('departureTime')
              .get();

      final flights =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return FlightModel.fromJson(data, doc.id);
          }).toList();

      print('Flights fetched: ${flights.length}');
      return flights;
    } catch (e) {
      print('Lỗi khi lấy danh sách chuyến bay: $e');
      rethrow;
    }
  }

  Future<void> searchFlights(FlightSearchModel searchData) async {
    try {
      if (searchData.departureCity == null || searchData.arrivalCity == null) {
        throw Exception('Vui lòng chọn điểm đi và điểm đến');
      }
      if (searchData.departureCity == searchData.arrivalCity) {
        throw Exception('Điểm đi và điểm đến không được trùng nhau');
      }
      if (searchData.departureDate == null) {
        throw Exception('Vui lòng chọn ngày đi');
      }
      if (searchData.isRoundTrip &&
          (searchData.returnDate == null ||
              searchData.returnDate!.isBefore(searchData.departureDate!))) {
        throw Exception('Ngày về phải sau ngày đi');
      }
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm chuyến bay: $e');
    }
  }

  Future<String> _generateFlightId() async {
    final metadataRef = _firestore.collection('metadata').doc('flight_counter');
    return await _firestore.runTransaction<String>((transaction) async {
      final snapshot = await transaction.get(metadataRef);
      final currentCounter = int.parse(snapshot.data()?['counter'] ?? '0');
      final newCounter = currentCounter + 1;
      transaction.update(metadataRef, {'counter': newCounter.toString()});
      return 'flight$newCounter';
    });
  }

  Future<void> addFlight(FlightModel flight) async {
    final newFlightId = await _generateFlightId();
    final flightWithId = FlightModel(
      id:
          flight.id.isEmpty
              ? 'VN${newFlightId.replaceFirst('flight', '')}'
              : flight.id,
      documentId: newFlightId,
      departureCity: flight.departureCity,
      arrivalCity: flight.arrivalCity,
      departureAirportName: flight.departureAirportName,
      arrivalAirportName: flight.arrivalAirportName,
      departureAirportCode: flight.departureAirportCode,
      arrivalAirportCode: flight.arrivalAirportCode,
      departureTime: flight.departureTime,
      arrivalTime: flight.arrivalTime,
      price: flight.price,
      airlineId: flight.airlineId,
    );
    await _firestore
        .collection('flights')
        .doc(newFlightId)
        .set(flightWithId.toJson());
  }

  Future<void> updateFlight(FlightModel flight) async {
    final docRef = _firestore.collection('flights').doc(flight.documentId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Document with ID ${flight.documentId} not found');
    }
    await docRef.update(flight.toJson());
  }

  Future<void> deleteFlight(String documentId) async {
    final docRef = _firestore.collection('flights').doc(documentId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Document with ID $documentId not found');
    }
    await docRef.delete();
  }

  Future<Map<String, bool>> getSeats(String flightId) async {
    try {
      final snapshot =
          await _firestore
              .collection('flights')
              .doc(flightId)
              .collection('seats')
              .get();
      final seats = <String, bool>{};
      for (var doc in snapshot.docs) {
        seats[doc.id] = doc['isBooked'] as bool;
      }
      final defaultSeats = {
        '1A': false,
        '1B': false,
        '1C': false,
        '1D': false,
        '2A': false,
        '2B': false,
        '2C': false,
        '2D': false,
        '3A': false,
        '3B': false,
        '3C': false,
        '3D': false,
        '4A': false,
        '4B': false,
        '4C': false,
        '4D': false,
        '5A': false,
        '5B': false,
        '5C': false,
        '5D': false,
        '6A': false,
        '6B': false,
        '6C': false,
        '6D': false,
        '7A': false,
        '7B': false,
        '7C': false,
        '7D': false,
        '8A': false,
        '8B': false,
        '8C': false,
        '8D': false,
        '9A': false,
        '9B': false,
        '9C': false,
        '9D': false,
      };
      defaultSeats.forEach((seatId, isBooked) {
        if (!seats.containsKey(seatId)) {
          seats[seatId] = isBooked;
          _firestore
              .collection('flights')
              .doc(flightId)
              .collection('seats')
              .doc(seatId)
              .set({'isBooked': isBooked});
        }
      });
      return seats;
    } catch (e) {
      print('Error fetching seats: $e');
      throw Exception('Lỗi khi lấy danh sách ghế: $e');
    }
  }

  Future<void> bookSeat(String flightId, String seatId) async {
    try {
      final seatDoc =
          await _firestore
              .collection('flights')
              .doc(flightId)
              .collection('seats')
              .doc(seatId)
              .get();
      if (!seatDoc.exists) {
        throw Exception('Seat $seatId does not exist for flight $flightId');
      }
      if (seatDoc.data()!['isBooked'] == true) {
        throw Exception('Seat $seatId is already booked for flight $flightId');
      }
      await _firestore
          .collection('flights')
          .doc(flightId)
          .collection('seats')
          .doc(seatId)
          .update({'isBooked': true});
      print('Seat booked: $seatId for flight $flightId');
    } catch (e) {
      print('Error booking seat: $e');
      throw Exception('Lỗi khi đặt ghế: $e');
    }
  }

  Future<void> bookTicket({
    required FlightModel flight,
    required Passenger passenger,
    required String seat,
    required double ticketPrice,
    required String phoneNumber,
    required String email,
    required double discountPercentage,
  }) async {
    try {
      final ticket = Ticket(
        id: '',
        documentId: '',
        flight: flight,
        passenger: passenger,
        seat: seat,
        ticketPrice: ticketPrice,
        bookingTime: DateTime.now(),
        phoneNumber: phoneNumber,
        email: email,
        discountPercentage: discountPercentage,
      );
      await _firestore.collection('tickets').add(ticket.toJson());
      print(
        'Ticket booked for flight: ${flight.id}, seat: $seat, discount: $discountPercentage%',
      );
    } catch (e) {
      print('Error booking ticket: $e');
      throw Exception('Lỗi khi đặt vé: $e');
    }
  }

  Future<List<Ticket>> getUserTickets(String email) async {
    try {
      final snapshot =
          await _firestore
              .collection('tickets')
              .where('passenger.email', isEqualTo: email)
              .orderBy('bookingTime', descending: true)
              .get();
      final tickets =
          snapshot.docs
              .map((doc) => Ticket.fromJson(doc.data(), doc.id))
              .toList();
      print('Fetched ${tickets.length} tickets for email: $email');
      return tickets;
    } catch (e) {
      print('Error fetching tickets: $e');
      throw Exception('Lỗi khi lấy danh sách vé: $e');
    }
  }

  Future<List<DiscountModel>> getDiscounts() async {
    try {
      print('Fetching discounts from Firestore');
      final snapshot = await _firestore.collection('discounts').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final discountPercentage = double.tryParse(
          data['discountPercentage'].toString(),
        );
        if (discountPercentage == null) {
          print(
            'Invalid discountPercentage for ${data['code']}: ${data['discountPercentage']}',
          );
          throw Exception(
            'Invalid discountPercentage format for discount code ${data['code']}',
          );
        }
        DateTime? validUntil;
        if (data['validUntil'] is Timestamp) {
          validUntil = (data['validUntil'] as Timestamp).toDate();
        } else if (data['validUntil'] is String) {
          validUntil = DateTime.tryParse(data['validUntil']);
        }
        return DiscountModel(
          code: data['code'] ?? '',
          discountPercentage: discountPercentage,
          validUntil: validUntil,
          isActive: data['isActive'] ?? false,
          documentId: doc.id, // Sử dụng doc.id từ Firestore
        );
      }).toList();
    } catch (e) {
      print('Error fetching discounts: $e');
      throw Exception('Lỗi khi lấy danh sách mã giảm giá: $e');
    }
  }

  Future<void> addDiscount(DiscountModel discount) async {
    try {
      print('Adding discount with code: ${discount.code}');
      final docRef = _firestore.collection('discounts').doc(); // Tạo ID tự động
      final discountWithId = DiscountModel(
        code: discount.code,
        discountPercentage: discount.discountPercentage,
        validUntil: discount.validUntil,
        isActive: discount.isActive,
        documentId: docRef.id, // Gán ID tự động
      );
      await docRef.set(discountWithId.toJson());
      print('Discount added successfully: ${docRef.id}');
    } catch (e) {
      print('Error adding discount: $e');
      throw Exception('Lỗi khi thêm mã giảm giá: $e');
    }
  }

  Future<void> saveUsedDiscount(
    String userId,
    String discountCode,
    String flightId,
  ) async {
    try {
      await _firestore.collection('used_discounts').add({
        'userId': userId,
        'discountCode': discountCode,
        'flightId': flightId,
        'usedAt': DateTime.now().toIso8601String(),
        'isUsed': false,
      });
    } catch (e) {
      print('Error saving used discount: $e');
      throw Exception('Lỗi khi lưu mã giảm giá: $e');
    }
  }

  Future<void> markDiscountAsUsed(String userId, String discountCode) async {
    try {
      final snapshot =
          await _firestore
              .collection('used_discounts')
              .where('userId', isEqualTo: userId)
              .where('discountCode', isEqualTo: discountCode)
              .where('isUsed', isEqualTo: false)
              .get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({'isUsed': true});
        print('Marked discount code $discountCode as used for user $userId');
      }
    } catch (e) {
      print('Error marking discount as used: $e');
      throw Exception('Lỗi khi đánh dấu mã giảm giá đã sử dụng: $e');
    }
  }

  Future<List<DiscountModel>> getUserDiscounts(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('used_discounts')
              .where('userId', isEqualTo: userId)
              .where('isUsed', isEqualTo: false)
              .get();
      final List<DiscountModel> userDiscounts = [];
      for (var doc in snapshot.docs) {
        final discountSnapshot =
            await _firestore
                .collection('discounts')
                .where('code', isEqualTo: doc['discountCode'])
                .where('isActive', isEqualTo: true)
                .get();
        for (var discountDoc in discountSnapshot.docs) {
          final data = discountDoc.data();
          final discountPercentage = double.tryParse(
            data['discountPercentage'].toString(),
          );
          if (discountPercentage == null) {
            print(
              'Invalid discountPercentage format for discount code ${data['code']}: ${data['discountPercentage']}',
            );
            continue;
          }
          DateTime? validUntil;
          if (data['validUntil'] is Timestamp) {
            validUntil = (data['validUntil'] as Timestamp).toDate();
          } else if (data['validUntil'] is String) {
            validUntil = DateTime.tryParse(data['validUntil']);
          }
          if (validUntil != null && validUntil.isBefore(DateTime.now())) {
            print(
              'Expired validUntil for discount code ${data['code']}: ${data['validUntil']}',
            );
            continue;
          }
          userDiscounts.add(
            DiscountModel.fromJson(data, discountDoc.id), // Truyền doc.id
          );
        }
      }
      print('Fetched ${userDiscounts.length} discounts for user $userId');
      return userDiscounts;
    } catch (e) {
      print('Error fetching user discounts: $e');
      throw Exception('Lỗi khi lấy danh sách mã giảm giá của người dùng: $e');
    }
  }

  Future<void> deleteDiscount(String documentId) async {
    try {
      print('Attempting to delete discount with documentId: $documentId');
      await FirebaseFirestore.instance
          .collection('discounts')
          .doc(documentId)
          .delete();
      print('Successfully deleted discount: $documentId');
    } catch (e) {
      print('Error deleting discount: $e');
      throw Exception('Failed to delete discount: $e');
    }
  }

  Future<bool> checkIfDiscountClaimed(
    String userId,
    String discountCode,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('used_discounts')
              .where('userId', isEqualTo: userId)
              .where('discountCode', isEqualTo: discountCode)
              .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking discount claim: $e');
      return false;
    }
  }
}
