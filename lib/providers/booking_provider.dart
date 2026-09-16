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

  // ---- In-progress booking selection ----
  Salon? selectedSalon;
  final Set<ServiceItem> selectedServices = {};
  Stylist? selectedStylist; // null = "Bất kỳ thợ nào"
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<String> availableSlots = [];
  bool isLoadingSlots = false;

  bool isSubmitting = false;
  String? errorMessage;

  // ---- My bookings ----
  List<Booking> myBookings = [];
  bool isLoadingMyBookings = false;

  int get selectedTotalPrice =>
      selectedServices.fold(0, (sum, s) => sum + s.priceVnd);

  Future<void> loadCatalog() async {
    isLoadingCatalog = true;
    notifyListeners();
    salons = await _repository.getSalons();
    services = await _repository.getServices();
    isLoadingCatalog = false;
    notifyListeners();
  }

  Future<void> selectSalon(Salon salon) async {
    selectedSalon = salon;
    selectedStylist = null;
    stylists = await _repository.getStylists(salon.id);
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
    notifyListeners();
    availableSlots = await _repository.getAvailableTimeSlots(
      salonId: selectedSalon!.id,
      date: date,
    );
    isLoadingSlots = false;
    notifyListeners();
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
      errorMessage = e.toString().replaceFirst('Exception: ', '');
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
    notifyListeners();
    myBookings = await _repository.getMyBookings(userId);
    isLoadingMyBookings = false;
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    await _repository.cancelBooking(bookingId);
    await loadMyBookings(userId);
  }
}
