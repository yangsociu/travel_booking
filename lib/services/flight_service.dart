// services/flight_service.dart
// Dịch vụ lấy dữ liệu từ Firestore
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/models/airline_model.dart';
import 'package:booking_app/models/destination_model.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/flight_search_model.dart';

class FlightService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getCities() async {
    try {
      final snapshot = await _firestore.collection('cities').get();
      final cities = snapshot.docs.map((doc) => doc['name'] as String).toList();
      print('Firestore cities fetched: ${snapshot.docs.length} documents');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Document data: $data');
        return data['name'] as String;
      }).toList();
    } catch (e) {
      print('Error fetching cities: $e');
      return []; // Trả về danh sách rỗng nếu lỗi
    }
  }

  Future<List<AirlineModel>> getAirlines() async {
    try {
      final snapshot = await _firestore.collection('airlines').get();
      return snapshot.docs
          .map((doc) => AirlineModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách hãng hàng không: $e');
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
      // Giả lập độ trễ để kiểm tra logic
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm chuyến bay: $e');
    }
  }

  // Tạo document ID tăng dần và thêm chuyến bay
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
      departureCode: flight.departureCode,
      arrivalCode: flight.arrivalCode,
      departureTime: flight.departureTime,
      arrivalTime: flight.arrivalTime,
      price: flight.price,
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

  //đặt ghé
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
      // Khởi tạo ghế mặc định nếu chưa có
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
  }) async {
    try {
      final ticket = Ticket(
        id: '', // Firestore sẽ tự sinh ID
        flight: flight,
        passenger: passenger,
        seat: seat,
        ticketPrice: ticketPrice,
        bookingTime: DateTime.now(),
      );
      await _firestore.collection('tickets').add(ticket.toJson());
      print('Ticket booked for flight: ${flight.id}, seat: $seat');
    } catch (e) {
      print('Error booking ticket: $e');
      throw Exception('Lỗi khi đặt vé: $e');
    }
  }
}
