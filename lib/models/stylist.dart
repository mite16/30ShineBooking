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

  factory Stylist.fromJson(Map<String, dynamic> json) {
    return Stylist(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      name: json['name'] as String,
      level: json['level'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
