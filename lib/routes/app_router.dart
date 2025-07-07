import 'package:booking_app/screens/admin/admin_booking_management_screen.dart'
    as booking;
import 'package:booking_app/screens/admin/admin_dashboard_screen.dart';
import 'package:booking_app/screens/admin/add_discount_screen.dart';
import 'package:booking_app/screens/admin/admin_flight_management_screen.dart'
    as flight;
import 'package:booking_app/screens/admin/admin_hotel_booking_management_screen.dart'
    as hotel; // New import
import 'package:booking_app/screens/auth/login_screen.dart';
import 'package:booking_app/screens/auth/register_screen.dart';
import 'package:booking_app/screens/home/home_screen.dart';
import 'package:booking_app/screens/ticket_history/ticket_history_screen.dart';
import 'package:booking_app/screens/profile/profile_screen.dart';
import 'package:booking_app/screens/flight_selection/date_selection_screen.dart';
import 'package:booking_app/screens/flight_selection/flight_selection_screen.dart';
import 'package:booking_app/screens/seat_selection/seat_selection_screen.dart';
import 'package:booking_app/screens/payment/payment_screen.dart';
import 'package:booking_app/screens/payment/payment_success_screen.dart';
import 'package:booking_app/screens/passenger_info/passenger_info_screen.dart';
import 'package:booking_app/models/passenger.dart';
import 'package:booking_app/models/flight_model.dart';
import 'package:booking_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/screens/hotel/hotel_list_screen.dart';
import 'package:booking_app/screens/hotel/hotel_detail_screen.dart';
import 'package:booking_app/models/hotel_model.dart';
import 'package:booking_app/services/hotel_service.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.dateSelection:
        return MaterialPageRoute(builder: (_) => const DateSelectionScreen());
      case AppRoutes.flightSelection:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => FlightSelectionScreen(
                departureCity: args?['departureCity'] as String?,
                arrivalCity: args?['arrivalCity'] as String?,
                departureDate: args?['departureDate'] as DateTime,
                returnDate: args?['returnDate'] as DateTime?,
                passengerCount: args?['passengerCount'] as int? ?? 1,
              ),
        );
      case AppRoutes.passengerInfo:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args?['passengerCount'] == null) {
          print('Warning: passengerCount is null in passengerInfo route');
        }
        return MaterialPageRoute(
          builder:
              (_) => PassengerInfoScreen(
                flight: args?['flight'] as FlightModel,
                returnFlight: args?['returnFlight'] as FlightModel?,
                passengerCount: args?['passengerCount'] as int? ?? 1,
              ),
        );
      case AppRoutes.seatSelection:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => SeatSelectionScreen(
                flight: args?['flight'] as FlightModel,
                returnFlight: args?['returnFlight'] as FlightModel?,
                passengers: args?['passengers'] as List<Passenger>,
                phoneNumber: args?['phoneNumber'] as String,
                email: args?['email'] as String,
              ),
        );
      case AppRoutes.payment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => PaymentScreen(
                flight: args?['flight'] as FlightModel,
                returnFlight: args?['returnFlight'] as FlightModel?,
                passengers: args?['passengers'] as List<Passenger>,
                selectedSeats: (args?['selectedSeats'] as List<String>?) ?? [],
                returnSelectedSeats:
                    (args?['returnSelectedSeats'] as List<String>?) ?? [],
                phoneNumber: args?['phoneNumber'] as String,
                email: args?['email'] as String,
                ticketPrice: args?['ticketPrice'] as String,
                duration: args?['duration'] as String,
              ),
        );
      case AppRoutes.paymentSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => PaymentSuccessScreen(
                flight: args?['flight'] as FlightModel,
                passengers: args?['passengers'] as List<Passenger>,
                selectedSeats: args?['selectedSeats'] as List<String>,
                returnFlight: args?['returnFlight'] as FlightModel?,
                returnSelectedSeats:
                    args?['returnSelectedSeats'] as List<String>,
                totalPrice: args?['totalPrice'] as String,
                duration: args?['duration'] as String,
                discountPercentage:
                    args?['discountPercentage'] as double? ?? 0.0,
              ),
        );
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreenWrapper(),
        );
      case AppRoutes.adminFlightManagement:
        return MaterialPageRoute(
          builder: (_) => const flight.AdminFlightManagementScreenWrapper(),
        );
      case AppRoutes.adminBookingManagement:
        return MaterialPageRoute(
          builder: (_) => const booking.AdminBookingManagementScreenWrapper(),
        );
      case AppRoutes.adminHotelBookingManagement:
        return MaterialPageRoute(
          builder:
              (_) => const hotel.AdminHotelBookingManagementScreenWrapper(),
        );
      case AppRoutes.addDiscount:
        return MaterialPageRoute(
          builder: (_) => const AddDiscountScreenWrapper(),
          settings: settings,
        );
      case AppRoutes.ticketHistory:
        return MaterialPageRoute(
          builder:
              (_) => TicketHistoryScreen(
                flightService: FlightService(),
                hotelService: HotelService(),
              ),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(flightService: FlightService()),
        );
      case AppRoutes.hotelList:
        return MaterialPageRoute(
          builder: (_) => HotelListScreen(hotelService: HotelService()),
        );
      case AppRoutes.hotelDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => HotelDetailScreen(hotel: args?['hotel'] as HotelModel),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Không tìm thấy trang: ${settings.name}'),
                ),
              ),
        );
    }
  }
}
