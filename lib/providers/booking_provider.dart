import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/salon.dart';
import '../models/service_item.dart';
import '../models/stylist.dart';
import '../repositories/booking_repository.dart';

/// Drives both the multi-step "new booking" flow (pick salon -> services ->
/// stylist/time -> review) and the "My bookings" list.
class BookingProvider extends ChangeNotifier {
  BookingProvider(this._repository);

  final BookingRepository _repository;

  // ---- Catalog data ----
  List<Salon> salons = [];
  List<ServiceItem> services = [];
  List<Stylist> stylists = [];
  bool isLoadingCatalog = false;
  String? catalogError;

  // ---- In-progress booking selection ----
  Salon? selectedSalon;
  final Set<ServiceItem> selectedServices = {};
  Stylist? selectedStylist; // null = "Bất kỳ thợ nào"
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<String> availableSlots = [];
  bool isLoadingSlots = false;
  String? slotsError;

  bool isSubmitting = false;
  String? errorMessage;

  // ---- My bookings ----
  List<Booking> myBookings = [];
  bool isLoadingMyBookings = false;
  String? myBookingsError;

  int get selectedTotalPrice =>
      selectedServices.fold(0, (sum, s) => sum + s.priceVnd);

  Future<void> loadCatalog() async {
    isLoadingCatalog = true;
    catalogError = null;
    notifyListeners();
    try {
      salons = await _repository.getSalons();
      services = await _repository.getServices();
    } catch (e) {
      catalogError = _readable(e);
    } finally {
      isLoadingCatalog = false;
      notifyListeners();
    }
  }

  Future<void> selectSalon(Salon salon) async {
    selectedSalon = salon;
    selectedStylist = null;
    try {
      stylists = await _repository.getStylists(salon.id);
    } catch (_) {
      stylists = []; // Non-fatal: user can still book with "Bất kỳ".
    }
    notifyListeners();
  }

  void toggleService(ServiceItem service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    notifyListeners();
  }

  void selectStylist(Stylist? stylist) {
    selectedStylist = stylist;
    notifyListeners();
  }

  Future<void> selectDate(DateTime date) async {
    selectedDate = date;
    selectedTimeSlot = null;
    if (selectedSalon == null) return;
    isLoadingSlots = true;
    slotsError = null;
    notifyListeners();
    try {
      availableSlots = await _repository.getAvailableTimeSlots(
        salonId: selectedSalon!.id,
        date: date,
      );
    } catch (e) {
      availableSlots = [];
      slotsError = _readable(e);
    } finally {
      isLoadingSlots = false;
      notifyListeners();
    }
  }

  void selectTimeSlot(String slot) {
    selectedTimeSlot = slot;
    notifyListeners();
  }

  bool get canReview =>
      selectedSalon != null &&
      selectedServices.isNotEmpty &&
      selectedDate != null &&
      selectedTimeSlot != null;

  Future<Booking?> confirmBooking({required String userId, String? note}) async {
    if (!canReview) return null;
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final booking = await _repository.createBooking(
        userId: userId,
        salon: selectedSalon!,
        services: selectedServices.toList(),
        stylistId: selectedStylist?.id,
        stylistName: selectedStylist?.name ?? 'Bất kỳ',
        date: selectedDate!,
        timeSlot: selectedTimeSlot!,
        note: note,
      );
      // Optimistic update: show it in "My bookings" immediately, even if
      // that tab was already built and isn't re-fetching right now.
      myBookings = [booking, ...myBookings];
      _resetSelection();
      return booking;
    } catch (e) {
      errorMessage = _readable(e);
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void _resetSelection() {
    selectedSalon = null;
    selectedServices.clear();
    selectedStylist = null;
    selectedDate = null;
    selectedTimeSlot = null;
    availableSlots = [];
  }

  Future<void> loadMyBookings(String userId) async {
    isLoadingMyBookings = true;
    myBookingsError = null;
    notifyListeners();
    try {
      myBookings = await _repository.getMyBookings(userId);
    } catch (e) {
      myBookingsError = _readable(e);
    } finally {
      isLoadingMyBookings = false;
      notifyListeners();
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    try {
      await _repository.cancelBooking(bookingId);
    } finally {
      await loadMyBookings(userId);
    }
  }

  String _readable(Object e) => e.toString().replaceFirst('Exception: ', '');
}
