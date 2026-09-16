class AppUser {
  final String id;
  final String fullName;
  final String phone;
  final String email;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phone': phone,
        'email': email,
      };
}
