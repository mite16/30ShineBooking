class Salon {
  final String id;
  final String name;
  final String district;
  final String address;
  final double rating;
  final String openHours;
  final String imageAsset;

  const Salon({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.rating,
    required this.openHours,
    this.imageAsset = '',
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      openHours: json['openHours'] as String,
    );
  }
}
