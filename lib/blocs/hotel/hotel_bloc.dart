import 'package:bloc/bloc.dart';
import 'package:booking_app/models/hotel_model.dart';
import 'package:booking_app/services/hotel_service.dart';
import 'package:booking_app/blocs/hotel/hotel_event.dart';
import 'package:booking_app/blocs/hotel/hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelService hotelService;

  HotelBloc({required this.hotelService}) : super(HotelInitial()) {
    print('HotelBloc initialized: $this'); // Log để kiểm tra instance
    on<LoadHotels>(_onLoadHotels);
    on<BookHotel>(_onBookHotel);
    on<CancelHotelBooking>(_onCancelHotelBooking);
    on<LoadUserBookings>(_onLoadUserBookings); // Đảm bảo dòng này có mặt
    on<LoadAllHotelBookings>(_onLoadAllHotelBookings);
  }

  Future<void> _onLoadHotels(LoadHotels event, Emitter<HotelState> emit) async {
    print('Handling LoadHotels');
    emit(HotelLoading());
    try {
      final hotels = await hotelService.getHotels();
      emit(HotelLoaded(hotels));
    } catch (e) {
      print('Error in _onLoadHotels: $e');
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onBookHotel(BookHotel event, Emitter<HotelState> emit) async {
    print('Handling BookHotel');
    emit(HotelLoading());
    try {
      await hotelService.bookHotel(event.booking);
      emit(HotelBookingSuccess());
    } catch (e) {
      print('Error in _onBookHotel: $e');
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onCancelHotelBooking(
    CancelHotelBooking event,
    Emitter<HotelState> emit,
  ) async {
    print(
      'Handling CancelHotelBooking: bookingId=${event.bookingId}, userId=${event.userId}',
    );
    emit(HotelLoading());
    try {
      await hotelService.cancelBooking(event.bookingId, event.userId);
      print('Cancel successful for bookingId=${event.bookingId}');
      emit(HotelBookingCancelSuccess(event.bookingId));
    } catch (e) {
      print('Error in _onCancelHotelBooking: $e');
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onLoadUserBookings(
    LoadUserBookings event,
    Emitter<HotelState> emit,
  ) async {
    print('Handling LoadUserBookings for userId=${event.userId}');
    emit(HotelLoading());
    try {
      final bookings = await hotelService.getUserBookings(event.userId);
      print('Loaded ${bookings.length} bookings for userId=${event.userId}');
      emit(UserBookingsLoaded(bookings));
    } catch (e) {
      print('Error in _onLoadUserBookings: $e');
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onLoadAllHotelBookings(
    LoadAllHotelBookings event,
    Emitter<HotelState> emit,
  ) async {
    print('Handling LoadAllHotelBookings');
    emit(HotelLoading());
    try {
      final bookings = await hotelService.getAllHotelBookings();
      print('Loaded ${bookings.length} hotel bookings');
      emit(AllHotelBookingsLoaded(bookings));
    } catch (e) {
      print('Error in _onLoadAllHotelBookings: $e');
      emit(HotelError(e.toString()));
    }
  }
}
