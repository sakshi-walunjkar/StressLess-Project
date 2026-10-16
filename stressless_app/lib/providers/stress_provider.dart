import 'package:flutter/foundation.dart';
import '../models/stress_result_model.dart';
import '../services/stress_service.dart';

/// Stress data state provider
/// Manages stress prediction results and history
class StressProvider extends ChangeNotifier {
  final StressService _stressService = StressService();

  StressResultModel? _currentResult;
  List<StressResultModel> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  StressResultModel? get currentResult => _currentResult;
  List<StressResultModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Predict stress level from questionnaire responses
  Future<bool> predictStress({
    required List<int> responses,
    required String userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _stressService.predictStress(
        responses: responses,
        userId: userId,
      );

      if (result['success'] == true) {
        _currentResult = result['result'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load stress assessment history
  Future<void> loadHistory({
    required String userId,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _stressService.getHistory(
        userId: userId,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
      );

      if (result['success'] == true) {
        _history = result['history'];
      } else {
        _errorMessage = result['message'];
        _history = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      _history = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete history item
  Future<bool> deleteHistoryItem(String id) async {
    try {
      final result = await _stressService.deleteHistory(id);

      if (result['success'] == true) {
        _history.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear current result
  void clearCurrentResult() {
    _currentResult = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get history filtered by date range
  List<StressResultModel> getHistoryByDateRange(DateTime start, DateTime end) {
    return _history.where((result) {
      return result.timestamp.isAfter(start) && result.timestamp.isBefore(end);
    }).toList();
  }

  /// Calculate average stress level
  double getAverageStressLevel({int? days}) {
    if (_history.isEmpty) return 0.0;

    List<StressResultModel> filteredHistory = _history;

    if (days != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      filteredHistory = _history.where((result) {
        return result.timestamp.isAfter(cutoffDate);
      }).toList();
    }

    if (filteredHistory.isEmpty) return 0.0;

    final sum = filteredHistory.fold<int>(
      0,
      (prev, result) => prev + result.stressLevelValue,
    );

    return sum / filteredHistory.length;
  }

  /// Get stress trend (improving, stable, worsening)
  String getStressTrend({int days = 7}) {
    if (_history.length < 2) return 'stable';

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentHistory = _history.where((result) {
      return result.timestamp.isAfter(cutoffDate);
    }).toList();

    if (recentHistory.length < 2) return 'stable';

    // Sort by date
    recentHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Compare first half vs second half
    final midPoint = recentHistory.length ~/ 2;
    final firstHalf = recentHistory.sublist(0, midPoint);
    final secondHalf = recentHistory.sublist(midPoint);

    final firstAvg = firstHalf.fold<int>(
            0, (prev, result) => prev + result.stressLevelValue) /
        firstHalf.length;
    final secondAvg = secondHalf.fold<int>(
            0, (prev, result) => prev + result.stressLevelValue) /
        secondHalf.length;

    if (secondAvg < firstAvg - 0.5) {
      return 'improving';
    } else if (secondAvg > firstAvg + 0.5) {
      return 'worsening';
    } else {
      return 'stable';
    }
  }
}
