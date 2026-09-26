import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SessionService _sessionService;

  UserProvider({
    ApiService? apiService,
    SessionService? sessionService,
  })  : _apiService = apiService ?? ApiService(),
        _sessionService = sessionService ?? SessionService();

  UserModel _user = const UserModel(
    phone: '',
    balance: 0,
    loggedIn: false,
  );

  bool _loading = false;
  bool _initialized = false;
  String? _error;

  UserModel get user => _user;
  bool get loading => _loading;
  bool get initialized => _initialized;
  String? get error => _error;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final loggedIn = await _sessionService.isLoggedIn();

      if (loggedIn) {
        final phone = await _sessionService.getPhone();

        _user = _user.copyWith(
          phone: phone ?? '',
          loggedIn: true,
        );
      }
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String phone) async {
    await _sessionService.saveSession(phone: phone);

    _user = _user.copyWith(
      phone: phone,
      loggedIn: true,
    );

    _error = null;
    notifyListeners();
  }

  Future<void> refreshBalance(
    Map<String, String> headers,
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getBalance(
        headers: headers,
      );

      final rawBalance = data['balance'];

      final balance = rawBalance is int
          ? rawBalance
          : int.tryParse(
                rawBalance?.toString() ?? '0',
              ) ??
              0;

      _user = _user.copyWith(
        balance: balance,
        loggedIn: true,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _sessionService.clearSession();

    _user = const UserModel(
      phone: '',
      balance: 0,
      loggedIn: false,
    );

    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
