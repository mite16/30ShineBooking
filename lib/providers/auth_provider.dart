import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../repositories/auth_repository.dart';

const _kTokenKey = 'auth_token';
const _kUserKey = 'auth_user';

/// Holds the authentication/session state for the whole app, following the
/// Splash -> (token?) -> Home/Login pattern from Module 10.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCheckingSession = true;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isCheckingSession => _isCheckingSession;
  String? get errorMessage => _errorMessage;

  /// Called once from SplashScreen: restores the session if a token was
  /// saved from a previous run, without hitting the network again.
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kTokenKey);
    final userJson = prefs.getString(_kUserKey);

    if (token != null && userJson != null) {
      _currentUser = AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }
    _isCheckingSession = false;
    notifyListeners();
  }

  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _repository.login(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      await _persistSession(user);
      _currentUser = user;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _repository.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      await _persistSession(user);
      _currentUser = user;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserKey);
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _persistSession(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, 'mock_token_${user.id}');
    await prefs.setString(_kUserKey, jsonEncode(user.toJson()));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
