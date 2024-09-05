// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    final token = prefs.getString('auth_token');
    return token != null;
  }

  Future<void> login(String token) async {
    final prefs = await _prefs;
    await prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove('auth_token');
  }
}
