import 'package:flutter/foundation.dart';
import 'package:tubes/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isAuthenticated = false;

  AuthProvider(this._authService);
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    var success = await _authService.login(email, password);
    print(success);
    if (success) {
      _isAuthenticated = true;
      // await _updateUser();
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup(String username, String email, String password) async {
    bool success = await _authService.signup(username, email, password);
    print(success);
    if (success) {
      _isAuthenticated = true;
      // await _updateUser();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    // _user = null;
    notifyListeners();
  }
}
