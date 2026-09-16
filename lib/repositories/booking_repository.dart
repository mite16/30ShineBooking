import '../data/mock_data.dart';
import '../models/booking.dart';
import '../models/salon.dart';
import '../models/service_item.dart';
import '../models/stylist.dart';

/// Mock "database" for salons/services/stylists/bookings. Same shape as
/// FakeDatabase from Module 9: an in-memory table with async methods so
/// swapping in a real REST API later (Slot 12) only touches this file.
class BookingRepository {
  final List<Booking> _bookings = [];
  int _autoId = 0;

  Future<List<Salon>> getSalons() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(MockData.salons);
  }

  Future<List<ServiceItem>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.services);
  }

  Future<List<Stylist>> getStylists(String salonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.stylistsFor(salonId);
  }

  Future<List<String>> getAvailableTimeSlots({
    required String salonId,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock: every slot is available except ones already booked that day.
    final taken = _bookings
        .where((b) =>
            b.salonId == salonId &&
            b.status != BookingStatus.cancelled &&
            _isSameDay(b.date, date))
        .map((b) => b.timeSlot)
        .toSet();
    return MockData.timeSlots.where((t) => !taken.contains(t)).toList();
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
    await Future.delayed(const Duration(seconds: 1));

    final booking = Booking(
      id: 'bk${++_autoId}',
      userId: userId,
      salonId: salon.id,
      salonName: salon.name,
      services: services,
      stylistId: stylistId,
      stylistName: stylistName,
      date: date,
      timeSlot: timeSlot,
      status: BookingStatus.pending,
      note: note,
    );
    _bookings.add(booking);
    return booking;
  }

  Future<List<Booking>> getMyBookings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mine = _bookings.where((b) => b.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return mine;
  }

  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] =
          _bookings[index].copyWith(status: BookingStatus.cancelled);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
