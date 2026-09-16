import 'service_item.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Chờ xác nhận';
      case BookingStatus.confirmed:
        return 'Đã xác nhận';
      case BookingStatus.completed:
        return 'Hoàn thành';
      case BookingStatus.cancelled:
        return 'Đã huỷ';
    }
  }
}

class Booking {
  final String id;
  final String userId;
  final String salonId;
  final String salonName;
  final List<ServiceItem> services;
  final String? stylistId;
  final String stylistName; // "Bất kỳ" if stylistId is null
  final DateTime date;
  final String timeSlot; // e.g. "14:30"
  final BookingStatus status;
  final String? note;

  const Booking({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.salonName,
    required this.services,
    required this.stylistId,
    required this.stylistName,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.note,
  });

  int get totalPriceVnd => services.fold(0, (sum, s) => sum + s.priceVnd);

  int get totalDurationMinutes =>
      services.fold(0, (sum, s) => sum + s.durationMinutes);

  Booking copyWith({BookingStatus? status}) {
    return Booking(
      id: id,
      userId: userId,
      salonId: salonId,
      salonName: salonName,
      services: services,
      stylistId: stylistId,
      stylistName: stylistName,
      date: date,
      timeSlot: timeSlot,
      status: status ?? this.status,
      note: note,
    );
  }
}
