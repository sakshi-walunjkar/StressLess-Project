import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import 'api_service.dart';

/// Chat service for AI-powered stress management conversations
class ChatService {
  final ApiService _apiService = ApiService();

  /// Send message to AI chatbot and get response
  Future<String> sendMessage({
    required String message,
    required List<dynamic> conversationHistory,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.chatMessage,
        data: {
          'message': message,
          'history': conversationHistory
              .map((msg) => {
                    'role': msg.isUser ? 'user' : 'assistant',
                    'content': msg.text,
                  })
              .toList(),
        },
      );

      if (response.statusCode == 200) {
        return response.data['response'] ?? 'I\'m here to help!';
      }

      return 'Sorry, I couldn\'t process that. Please try again.';
    } catch (e) {
      print('Chat error: $e');
      return 'Sorry, I\'m having trouble connecting. Please check your internet connection.';
    }
  }

  /// Get chat history for user
  Future<List<dynamic>> getChatHistory() async {
    try {
      final response = await _apiService.get(ApiEndpoints.chatHistory);

      if (response.statusCode == 200) {
        return response.data['messages'] ?? [];
      }

      return [];
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }

  /// Clear chat history
  Future<bool> clearChatHistory() async {
    try {
      final response = await _apiService.delete(ApiEndpoints.chatHistory);
      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing chat history: $e');
      return false;
    }
  }
}
