import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication state provider
/// Manages user authentication state throughout the app
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// Initialize authentication state on app start
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.initializeAuth();
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        // Load user data from secure storage
        final userData = await _authService.getUserData();
        if (userData['id'] != null) {
          _user = UserModel(
            id: userData['id']!,
            email: userData['email'] ?? '',
            name: userData['name'] ?? '',
            age:
                userData['age'] != null ? int.tryParse(userData['age']!) : null,
            gender: userData['gender'],
            createdAt: DateTime.now(),
          );
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register new user with age and gender
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        age: age,
        gender: gender,
      );

      if (result['success'] == true) {
        _user = result['user'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please check your connection';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _user = result['user'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please check your connection';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to logout';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Update user profile
  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
