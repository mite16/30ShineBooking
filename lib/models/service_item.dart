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
    required this.description,
    required this.priceVnd,
    required this.durationMinutes,
    required this.category,
  });
}
