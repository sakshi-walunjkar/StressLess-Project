/// Stress assessment result model
/// Contains the ML prediction results and recommendations
class StressResultModel {
  final String? id;
  final String userId;
  final String stressLevel; // 'low', 'moderate', 'high'
  final double confidence;
  final List<int> responses;
  final Map<String, dynamic>? modelPredictions; // SVM, RF, ANN predictions
  final List<String> recommendations;
  final DateTime timestamp;

  StressResultModel({
    this.id,
    required this.userId,
    required this.stressLevel,
    required this.confidence,
    required this.responses,
    this.modelPredictions,
    required this.recommendations,
    required this.timestamp,
  });

  /// Create StressResultModel from JSON (from API response)
  factory StressResultModel.fromJson(Map<String, dynamic> json) {
    return StressResultModel(
      id: json['id'] ?? json['_id'],
      userId: json['user_id'] ?? json['userId'] ?? '',
      stressLevel: json['stress_level'] ?? json['stressLevel'] ?? 'moderate',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      responses:
          json['responses'] != null ? List<int>.from(json['responses']) : [],
      modelPredictions: json['model_predictions'] ?? json['modelPredictions'],
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  /// Convert StressResultModel to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'stress_level': stressLevel,
      'confidence': confidence,
      'responses': responses,
      'model_predictions': modelPredictions,
      'recommendations': recommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Get stress level as integer (1=low, 2=moderate, 3=high)
  /// Used for charts and calculations
  int get stressLevelValue {
    switch (stressLevel.toLowerCase()) {
      case 'low':
        return 1;
      case 'moderate':
      case 'medium':
        return 2;
      case 'high':
        return 3;
      default:
        return 0;
    }
  }

  /// Get formatted confidence percentage (e.g., "85.5%")
  String get confidencePercentage {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  /// Get user-friendly stress level description
  String get stressDescription {
    switch (stressLevel.toLowerCase()) {
      case 'low':
        return 'Your stress level is well managed. Keep up the good work!';
      case 'moderate':
      case 'medium':
        return 'Your stress level is moderate. Consider taking some time for self-care.';
      case 'high':
        return 'Your stress level is high. Please consider seeking professional support.';
      default:
        return 'Unable to determine stress level.';
    }
  }

  /// Create a copy of StressResultModel with updated fields
  StressResultModel copyWith({
    String? id,
    String? userId,
    String? stressLevel,
    double? confidence,
    List<int>? responses,
    Map<String, dynamic>? modelPredictions,
    List<String>? recommendations,
    DateTime? timestamp,
  }) {
    return StressResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stressLevel: stressLevel ?? this.stressLevel,
      confidence: confidence ?? this.confidence,
      responses: responses ?? this.responses,
      modelPredictions: modelPredictions ?? this.modelPredictions,
      recommendations: recommendations ?? this.recommendations,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'StressResultModel(stressLevel: $stressLevel, confidence: $confidence)';
  }
}
