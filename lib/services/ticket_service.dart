import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/models/ticket.dart';

class TicketService {
  final CollectionReference _ticketsCollection = FirebaseFirestore.instance
      .collection('tickets');

  Future<List<Ticket>> getAllTickets() async {
    try {
      final querySnapshot = await _ticketsCollection.get();
      print('Fetched ${querySnapshot.docs.length} tickets from Firestore');
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data == null) {
              print('Warning: Null data for document ${doc.id}');
              return null; // Bỏ qua vé lỗi
            }
            // Kiểm tra trường bắt buộc
            if (data['flight'] == null || data['passenger'] == null) {
              print(
                'Warning: Missing flight or passenger data in document ${doc.id}',
              );
              return null; // Bỏ qua vé lỗi
            }
            return Ticket(
              id: doc.id,
              documentId: doc.id,
              flight: FlightModel.fromJson(
                data['flight'] as Map<String, dynamic>,
                data['flight']['id'] as String? ?? doc.id,
              ),
              passenger: Passenger.fromJson(
                data['passenger'] as Map<String, dynamic>,
              ),
              seat: data['seat'] as String? ?? '',
              ticketPrice:
                  double.tryParse(data['ticketPrice']?.toString() ?? '0.0') ??
                  0.0,
              bookingTime:
                  DateTime.tryParse(data['bookingTime'] as String? ?? '') ??
                  DateTime.now(),
              phoneNumber: data['phoneNumber'] as String? ?? '',
              email: data['email'] as String? ?? '',
              discountPercentage:
                  double.tryParse(
                    data['discountPercentage']?.toString() ?? '0.0',
                  ) ??
                  0.0,
            );
          })
          .whereType<Ticket>() // Chỉ giữ lại các vé hợp lệ
          .toList();
    } catch (e) {
      print('Error in getAllTickets: $e');
      throw Exception('Lỗi khi lấy danh sách vé: $e');
    }
  }

  Future<void> deleteTicket(String documentId) async {
    try {
      print('Deleting ticket with documentId: $documentId');
      await _ticketsCollection.doc(documentId).delete();
      print('Ticket deleted successfully');
    } catch (e) {
      print('Error in deleteTicket: $e');
      throw Exception('Lỗi khi xóa vé: $e');
    }
  }
}
