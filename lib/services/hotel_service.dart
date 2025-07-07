import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_app/models/hotel_model.dart';

class HotelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HotelModel>> getHotels() async {
    try {
      final snapshot = await _firestore.collection('hotels').get();
      final hotels =
          snapshot.docs.map((doc) => HotelModel.fromFirestore(doc)).toList();
      print(
        'Fetched ${hotels.length} hotels: ${hotels.map((h) => h.name).toList()}',
      );
      return hotels;
    } catch (e) {
      print('Error fetching hotels: $e');
      throw Exception('Failed to fetch hotels: $e');
    }
  }

  Future<void> bookHotel(HotelBooking booking) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('No authenticated user found');
      }
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      print('Firestore request user ID: $currentUserId');
      print('Firebase ID token: $token');
      print('Booking data sent to Firestore: ${booking.toFirestore()}');
      await _firestore
          .collection('hotel_bookings')
          .doc(booking.id)
          .set(booking.toFirestore());
      print('Booking successful for booking ID: ${booking.id}');
    } catch (e) {
      print('Error booking hotel: $e');
      throw Exception('Failed to book hotel: $e');
    }
  }

  Future<List<HotelBooking>> getUserBookings(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('hotel_bookings')
              .where('userId', isEqualTo: userId)
              .get();
      final bookings =
          snapshot.docs.map((doc) => HotelBooking.fromFirestore(doc)).toList();
      print('Fetched ${bookings.length} bookings for user: $userId');
      return bookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    try {
      print(
        'Attempting to cancel booking: bookingId=$bookingId, userId=$userId',
      );
      final docRef = _firestore.collection('hotel_bookings').doc(bookingId);
      final doc = await docRef.get();
      if (!doc.exists) {
        print('Booking not found: $bookingId');
        throw Exception('Booking not found: $bookingId');
      }
      final data = doc.data() as Map<String, dynamic>;
      if (data['userId'] != userId) {
        print('Unauthorized: userId=$userId, booking userId=${data['userId']}');
        throw Exception(
          'Unauthorized: User $userId cannot cancel booking $bookingId',
        );
      }
      await docRef.delete();
      print('Booking cancelled successfully: $bookingId');
    } catch (e) {
      print('Error cancelling booking: $e');
      throw Exception('Failed to cancel booking: $e');
    }
  }

  Future<List<HotelBooking>> getAllHotelBookings() async {
    try {
      final snapshot = await _firestore.collection('hotel_bookings').get();
      final bookings =
          snapshot.docs.map((doc) => HotelBooking.fromFirestore(doc)).toList();
      print('Fetched ${bookings.length} hotel bookings');
      return bookings;
    } catch (e) {
      print('Error fetching all hotel bookings: $e');
      throw Exception('Failed to fetch all hotel bookings: $e');
    }
  }
}
