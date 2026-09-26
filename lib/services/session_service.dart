import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _loggedInKey = 'logged_in';
  static const String _phoneKey = 'phone';

  Future<void> saveSession({
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_phoneKey, phone);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_loggedInKey);
    await prefs.remove(_phoneKey);
  }
}
