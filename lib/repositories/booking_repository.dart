import '../models/booking.dart';
import '../models/salon.dart';
import '../models/service_item.dart';
import '../models/stylist.dart';
import '../services/api_client.dart';

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Talks to the Node/Express + MongoDB backend in `backend/` (see its
/// README for the full endpoint list). Same method signatures as the mock
/// version this replaced — BookingProvider and every screen needed no
/// changes, only this file did (Repository pattern, Module 3).
class BookingRepository {
  BookingRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<Salon>> getSalons() async {
    final json = await _client.get('/salons');
    return (json as List).map((s) => Salon.fromJson(s as Map<String, dynamic>)).toList();
  }

  Future<List<ServiceItem>> getServices() async {
    final json = await _client.get('/services');
    return (json as List).map((s) => ServiceItem.fromJson(s as Map<String, dynamic>)).toList();
  }

  Future<List<Stylist>> getStylists(String salonId) async {
    final json = await _client.get('/salons/$salonId/stylists');
    return (json as List).map((s) => Stylist.fromJson(s as Map<String, dynamic>)).toList();
  }

  Future<List<String>> getAvailableTimeSlots({
    required String salonId,
    required DateTime date,
  }) async {
    final json = await _client.get(
      '/bookings/available-slots?salonId=$salonId&date=${_isoDate(date)}',
      auth: true,
    );
    return (json as List).cast<String>();
  }

  Future<Booking> createBooking({
    required String userId,
    required Salon salon,
    required List<ServiceItem> services,
    required String? stylistId,
    required String stylistName,
    required DateTime date,
    required String timeSlot,
    String? note,
  }) async {
    final json = await _client.post(
      '/bookings',
      auth: true,
      body: {
        'salonId': salon.id,
        'serviceIds': services.map((s) => s.id).toList(),
        'stylistId': ?stylistId,
        'date': _isoDate(date),
        'timeSlot': timeSlot,
        'note': ?note,
      },
    );
    return Booking.fromJson(json as Map<String, dynamic>);
  }

  Future<List<Booking>> getMyBookings(String userId) async {
    final json = await _client.get('/bookings/my', auth: true);
    return (json as List).map((b) => Booking.fromJson(b as Map<String, dynamic>)).toList();
  }

  Future<void> cancelBooking(String bookingId) async {
    await _client.patch('/bookings/$bookingId/cancel', auth: true);
  }
}
