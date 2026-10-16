import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Service for capturing and analyzing facial data
class FacialDetectionService {
  final Dio _dio = Dio();
  static const String _apiUrl = 'http://10.0.2.2:5001/api/analyze-face';

  /// Capture image from camera and analyze facial data
  /// Returns: {facialExpression: String, eyeBlinkRate: int, stressScore: double}
  Future<Map<String, dynamic>> captureFacialData(CameraController controller) async {
    try {
      // Capture image
      final XFile imageFile = await controller.takePicture();
      
      // Read image as bytes
      final bytes = await File(imageFile.path).readAsBytes();
      
      // Convert to base64
      final base64Image = base64Encode(bytes);
      
      // Send to API for analysis
      final response = await _dio.post(
        _apiUrl,
        data: {
          'image': base64Image,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {
          'success': true,
          'facialExpression': response.data['facialExpression'],
          'eyeBlinkRate': response.data['eyeBlinkRate'],
          'stressScore': response.data['stressScore'],
          'confidence': response.data['confidence'],
        };
      } else {
        throw Exception('Analysis failed');
      }
    } catch (e) {
      print('Facial detection error: $e');
      throw Exception('Failed to analyze facial data: $e');
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('http://10.0.2.2:5001/api/test');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  /// Get API health status
  Future<Map<String, dynamic>> getHealth() async {
    try {
      final response = await _dio.get('http://10.0.2.2:5001/health');
      return response.data;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
