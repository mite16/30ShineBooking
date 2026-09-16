enum ServiceCategory { cutWash, dyeing, perm, combo }

extension ServiceCategoryLabel on ServiceCategory {
  String get label {
    switch (this) {
      case ServiceCategory.cutWash:
        return 'Cắt & Gội';
      case ServiceCategory.dyeing:
        return 'Nhuộm tóc';
      case ServiceCategory.perm:
        return 'Uốn tóc';
      case ServiceCategory.combo:
        return 'Combo';
    }
  }
}

class ServiceItem {
  final String id;
  final String name;
  final String description;
  final int priceVnd;
  final int durationMinutes;
  final ServiceCategory category;

  const ServiceItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.priceVnd,
    required this.durationMinutes,
    this.category = ServiceCategory.cutWash,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      priceVnd: json['priceVnd'] as int,
      durationMinutes: json['durationMinutes'] as int,
      category: ServiceCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ServiceCategory.cutWash,
      ),
    );
  }

  /// Only the fields the backend stores in a booking snapshot are present.
  factory ServiceItem.fromBookingSnapshot(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] as String,
      name: json['name'] as String,
      priceVnd: json['priceVnd'] as int,
      durationMinutes: json['durationMinutes'] as int,
    );
  }
}
