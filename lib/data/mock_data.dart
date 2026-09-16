import '../models/salon.dart';
import '../models/service_item.dart';
import '../models/stylist.dart';

/// Seed data standing in for the real backend (Slot 12 will replace this
/// with a REST API on top of a real database, per the PE spec).
class MockData {
  static const List<Salon> salons = [
    Salon(
      id: 'sl1',
      name: '30Shine Cầu Giấy',
      district: 'Cầu Giấy',
      address: '123 Xuân Thuỷ, Cầu Giấy, Hà Nội',
      rating: 4.7,
      openHours: '08:00 - 21:00',
      imageAsset: 'assets/salons/salon1.png',
    ),
    Salon(
      id: 'sl2',
      name: '30Shine Đống Đa',
      district: 'Đống Đa',
      address: '45 Tây Sơn, Đống Đa, Hà Nội',
      rating: 4.5,
      openHours: '08:00 - 21:00',
      imageAsset: 'assets/salons/salon2.png',
    ),
    Salon(
      id: 'sl3',
      name: '30Shine Hai Bà Trưng',
      district: 'Hai Bà Trưng',
      address: '78 Bạch Mai, Hai Bà Trưng, Hà Nội',
      rating: 4.8,
      openHours: '08:00 - 21:30',
      imageAsset: 'assets/salons/salon3.png',
    ),
  ];

  static const List<ServiceItem> services = [
    ServiceItem(
      id: 'sv1',
      name: 'Cắt gội cơ bản',
      description: 'Cắt tạo kiểu + gội massage thư giãn',
      priceVnd: 89000,
      durationMinutes: 30,
      category: ServiceCategory.cutWash,
    ),
    ServiceItem(
      id: 'sv2',
      name: 'Cắt gội cao cấp',
      description: 'Tư vấn kiểu tóc riêng + gội dưỡng sinh',
      priceVnd: 159000,
      durationMinutes: 45,
      category: ServiceCategory.cutWash,
    ),
    ServiceItem(
      id: 'sv3',
      name: 'Nhuộm thời trang',
      description: 'Nhuộm phủ bạc hoặc lên màu thời trang',
      priceVnd: 350000,
      durationMinutes: 90,
      category: ServiceCategory.dyeing,
    ),
    ServiceItem(
      id: 'sv4',
      name: 'Uốn tạo kiểu',
      description: 'Uốn định hình theo khuôn mặt',
      priceVnd: 420000,
      durationMinutes: 120,
      category: ServiceCategory.perm,
    ),
    ServiceItem(
      id: 'sv5',
      name: 'Combo Cắt + Gội dưỡng + Ráy tai',
      description: 'Trải nghiệm đầy đủ, tiết kiệm hơn mua lẻ',
      priceVnd: 199000,
      durationMinutes: 60,
      category: ServiceCategory.combo,
    ),
  ];

  static List<Stylist> stylistsFor(String salonId) => [
        Stylist(
          id: '$salonId-st1',
          salonId: salonId,
          name: 'Anh Tuấn',
          level: 'Thợ chính',
          rating: 4.9,
        ),
        Stylist(
          id: '$salonId-st2',
          salonId: salonId,
          name: 'Anh Long',
          level: 'Thợ chính',
          rating: 4.6,
        ),
        Stylist(
          id: '$salonId-st3',
          salonId: salonId,
          name: 'Anh Đức',
          level: 'Thợ phụ',
          rating: 4.3,
        ),
      ];

  static const List<String> timeSlots = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '14:00',
    '14:30',
    '15:00',
    '16:00',
    '16:30',
    '19:00',
    '19:30',
  ];
}
