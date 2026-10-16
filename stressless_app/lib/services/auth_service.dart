import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// Authentication service
/// Handles user registration, login, logout, and token management
class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userAgeKey = 'user_age';
  static const String _userGenderKey = 'user_gender';

  /// Register new user with age and gender
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'age': age,
          'gender': gender,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Save auth token
        if (data['token'] != null) {
          await saveAuthToken(data['token']);
        }

        // Save user data
        if (data['user'] != null) {
          await saveUserData(UserModel.fromJson(data['user']));
        }

        return {
          'success': true,
          'message': 'Registration successful',
          'user':
              data['user'] != null ? UserModel.fromJson(data['user']) : null,
          'token': data['token'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Registration failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please check your connection',
      };
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save auth token
        if (data['token'] != null) {
          await saveAuthToken(data['token']);
        }

        // Save user data
        if (data['user'] != null) {
          await saveUserData(UserModel.fromJson(data['user']));
        }

        return {
          'success': true,
          'message': 'Login successful',
          'user':
              data['user'] != null ? UserModel.fromJson(data['user']) : null,
          'token': data['token'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Invalid email or password',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please check your connection',
      };
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Call logout API (optional)
      await _apiService.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue with local logout even if API fails
    } finally {
      // Clear local data
      await clearAuthData();
    }
  }

  /// Save auth token securely
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _apiService.setAuthToken(token);
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Save user data to secure storage including age and gender
  Future<void> saveUserData(UserModel user) async {
    await _storage.write(key: _userIdKey, value: user.id);
    await _storage.write(key: _userEmailKey, value: user.email);
    await _storage.write(key: _userNameKey, value: user.name);
    if (user.age != null) {
      await _storage.write(key: _userAgeKey, value: user.age.toString());
    }
    if (user.gender != null) {
      await _storage.write(key: _userGenderKey, value: user.gender);
    }
  }

  /// Get saved user data including age and gender
  Future<Map<String, String?>> getUserData() async {
    return {
      'id': await _storage.read(key: _userIdKey),
      'email': await _storage.read(key: _userEmailKey),
      'name': await _storage.read(key: _userNameKey),
      'age': await _storage.read(key: _userAgeKey),
      'gender': await _storage.read(key: _userGenderKey),
    };
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userAgeKey);
    await _storage.delete(key: _userGenderKey);
    _apiService.clearAuthToken();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Initialize auth (call on app start)
  Future<void> initializeAuth() async {
    final token = await getAuthToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
  }
}
