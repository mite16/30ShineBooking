import '../models/user.dart';
import '../services/api_client.dart';

/// Result of a successful login/register call: the JWT plus the user it
/// belongs to. AuthProvider persists [token] and uses it on every
/// subsequent authenticated request (Module 10 token-based auth pattern).
class AuthResult {
  const AuthResult({required this.token, required this.user});
  final String token;
  final AppUser user;
}

/// Talks to POST /api/auth/login and /register on the Node/Express backend
/// (see backend/README.md). Same method signatures as the mock version this
/// replaced, so AuthProvider needed no changes beyond reading `result.token`.
class AuthRepository {
  AuthRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final json = await _client.post('/auth/login', body: {
      'emailOrPhone': emailOrPhone,
      'password': password,
    });
    return AuthResult(
      token: json['token'] as String,
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Future<AuthResult> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final json = await _client.post('/auth/register', body: {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'password': password,
    });
    return AuthResult(
      token: json['token'] as String,
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
