import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

//Provides UI-friendly auth state, loading, and error handling
// on top of [AuthService].
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _authService.addListener(_relayAuthChanges);
  }

  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final result =
        await _authService.login(email: email, password: password);
    _errorMessage = result;
    _setLoading(false);
    return result == null;
  }

  Future<bool> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    _setLoading(true);
    final result = await _authService.signUp(
      email: email,
      name: name,
      password: password,
    );
    _errorMessage = result;
    _setLoading(false);
    return result == null;
  }

  Future<void> logout() async {
    await _authService.logout();
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshLastActive() => _authService.updateLastActive();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _relayAuthChanges() {
    // Propagate changes emitted by the underlying service (e.g., auth state).
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.removeListener(_relayAuthChanges);
    super.dispose();
  }
}
