import '../models/user.dart';

/// Mock authentication backend, following the same pattern used in class
/// (Module 10 demo): simulate network latency with [Future.delayed] and
/// validate locally. Slot 12 of the PE will replace this with real HTTP
/// calls to our own backend, without changing [AuthProvider]'s API.
class AuthRepository {
  // In-memory "users table" seeded with one demo account.
  final List<Map<String, String>> _users = [
    {
      'id': 'u1',
      'fullName': 'Nguyễn Văn Demo',
      'phone': '0900000000',
      'email': 'demo@30shine.vn',
      'password': '123456',
    },
  ];

  Future<AppUser> login({
    required String emailOrPhone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final match = _users.firstWhere(
      (u) =>
          (u['email'] == emailOrPhone || u['phone'] == emailOrPhone) &&
          u['password'] == password,
      orElse: () => const {},
    );

    if (match.isEmpty) {
      throw Exception('Sai email/số điện thoại hoặc mật khẩu');
    }

    return AppUser(
      id: match['id']!,
      fullName: match['fullName']!,
      phone: match['phone']!,
      email: match['email']!,
    );
  }

  Future<AppUser> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final exists = _users.any((u) => u['email'] == email || u['phone'] == phone);
    if (exists) {
      throw Exception('Email hoặc số điện thoại đã được sử dụng');
    }

    final id = 'u${_users.length + 1}';
    _users.add({
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'password': password,
    });

    return AppUser(id: id, fullName: fullName, phone: phone, email: email);
  }
}
