import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  Future<void> checkSession() async {
    try {
      final data = await _api.checkSession();
      _isLoggedIn = data['loggedIn'] == true;
      _username = data['username']?.toString();
      if (_isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username ?? '');
      }
      notifyListeners();
    } catch (_) {
      _isLoggedIn = false;
      _username = null;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final data = await _api.login(username, password);
      if (data['success'] == true) {
        _isLoggedIn = true;
        _username = username;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        notifyListeners();
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final data = await _api.register(username, email, password);
      if (data['error'] != null) return false;
      notifyListeners();
      return true;
    } catch (_) {}
    return false;
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {}
    _isLoggedIn = false;
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }
}
