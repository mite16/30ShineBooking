import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Thrown for any non-2xx response; carries the backend's own error message
/// (Module 8 pattern: throw on failure, let the UI show a friendly message).
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

const kAuthTokenKey = 'auth_token';

/// Thin wrapper around [http.Client] for the booking30shine REST API.
/// Same shape as the ApiService demo in Module 8, extended to attach the
/// JWT saved by AuthProvider to every authenticated request.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:4000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000/api'; // Android emulator -> host machine
    }
    return 'http://localhost:4000/api';
  }

  Future<dynamic> get(String path, {bool auth = false}) {
    return _send(auth: auth, request: (uri, headers) => _client.get(uri, headers: headers), path: path);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, bool auth = false}) {
    return _send(
      auth: auth,
      path: path,
      request: (uri, headers) => _client.post(uri, headers: headers, body: body == null ? null : jsonEncode(body)),
    );
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body, bool auth = false}) {
    return _send(
      auth: auth,
      path: path,
      request: (uri, headers) => _client.patch(uri, headers: headers, body: body == null ? null : jsonEncode(body)),
    );
  }

  Future<Map<String, String>> _headers({required bool auth}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(kAuthTokenKey);
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> _send({
    required bool auth,
    required String path,
    required Future<http.Response> Function(Uri uri, Map<String, String> headers) request,
  }) async {
    late http.Response response;
    try {
      final headers = await _headers(auth: auth);
      response = await request(Uri.parse('$baseUrl$path'), headers).timeout(const Duration(seconds: 10));
    } on SocketException {
      throw ApiException('Không thể kết nối máy chủ. Kiểm tra backend đã chạy chưa.');
    } on TimeoutException {
      throw ApiException('Máy chủ phản hồi quá lâu, vui lòng thử lại.');
    }

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = (decoded is Map && decoded['message'] != null)
          ? decoded['message'] as String
          : 'Yêu cầu thất bại (mã ${response.statusCode})';
      throw ApiException(message);
    }

    return decoded;
  }
}
