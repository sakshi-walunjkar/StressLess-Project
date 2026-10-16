import '../core/constants/api_endpoints.dart';
import '../models/stress_result_model.dart';
import 'api_service.dart';

/// Stress prediction service
/// Handles all stress-related API calls
class StressService {
  final ApiService _apiService = ApiService();

  /// Predict stress level based on questionnaire responses
  Future<Map<String, dynamic>> predictStress({
    required List<int> responses,
    required String userId,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.predictStress,
        data: {
          'user_id': userId,
          'responses': responses,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        return {
          'success': true,
          'result': StressResultModel.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': 'Prediction failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Get stress assessment history
  Future<Map<String, dynamic>> getHistory({
    required String userId,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'user_id': userId};

      if (limit != null) queryParams['limit'] = limit;
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        ApiEndpoints.getHistory,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<StressResultModel> history = [];

        if (data['history'] != null && data['history'] is List) {
          history = (data['history'] as List)
              .map((item) => StressResultModel.fromJson(item))
              .toList();
        }

        return {
          'success': true,
          'history': history,
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch history',
        'history': <StressResultModel>[],
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
        'history': <StressResultModel>[],
      };
    }
  }

  /// Get specific history item by ID
  Future<Map<String, dynamic>> getHistoryById(String id) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.getHistoryById}/$id',
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'result': StressResultModel.fromJson(response.data),
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch result',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Delete history item
  Future<Map<String, dynamic>> deleteHistory(String id) async {
    try {
      final response = await _apiService.delete(
        '${ApiEndpoints.deleteHistory}/$id',
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'History deleted successfully',
        };
      }

      return {
        'success': false,
        'message': 'Failed to delete history',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getStatistics(String userId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.getStatistics,
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'statistics': response.data,
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch statistics',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Get stress trends over time
  Future<Map<String, dynamic>> getTrends({
    required String userId,
    int days = 30,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.getTrends,
        queryParameters: {
          'user_id': userId,
          'days': days,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'trends': response.data,
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch trends',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
