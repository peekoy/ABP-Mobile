import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._dio);

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/api/authentications',
        data: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
          return true;
        }
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users',
        data: jsonEncode({
          'username': username,
          'displayName': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responselogin = await _dio.post(
          '/api/authentications',
          data: jsonEncode({'username': username, 'password': password}),
        );

        if (responselogin.statusCode == 200) {
          final token = responselogin.data['token'];
          if (token != null) {
            await _storage.write(key: 'jwt', value: token);
            return true;
          }
        }
      }
    } catch (e) {
      print('Signup error: $e');
    }
    return false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }
}
