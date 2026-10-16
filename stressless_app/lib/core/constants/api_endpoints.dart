/// API endpoint configuration
/// Change baseUrl when connecting to your backend
class ApiEndpoints {
  // Base URL - Update this with your backend URL
  static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // iOS simulator
  // static const String baseUrl = 'https://your-backend-url.com/api'; // Production

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // User Endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Chat Endpoints
  static const String chatMessage = '/chat/message';
  static const String chatHistory = '/chat/history';

  // Stress Prediction Endpoints
  static const String predictStress = '/stress/predict';
  static const String getHistory = '/stress/history';
  static const String getHistoryById = '/stress/history'; // + /{id}
  static const String deleteHistory = '/stress/history'; // + /{id}

  // Analytics Endpoints
  static const String getStatistics = '/analytics/statistics';
  static const String getTrends = '/analytics/trends';

  // Helper methods for full URLs
  static String get fullLoginUrl => baseUrl + login;
  static String get fullRegisterUrl => baseUrl + register;
  static String get fullChatUrl => baseUrl + chatMessage;
  static String get fullPredictUrl => baseUrl + predictStress;
  static String get fullHistoryUrl => baseUrl + getHistory;
  static String get fullProfileUrl => baseUrl + userProfile;

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
