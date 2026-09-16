class Stylist {
  final String id;
  final String salonId;
  final String name;
  final String level; // "Thợ chính" | "Thợ phụ"
  final double rating;

  const Stylist({
    required this.id,
    required this.salonId,
    required this.name,
    required this.level,
    required this.rating,
  });
}
