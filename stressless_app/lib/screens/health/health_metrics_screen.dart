import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../camera/facial_camera_screen.dart';

/// Health Metrics Input Screen
/// User enters health data and captures facial data for stress detection
class HealthMetricsScreen extends StatefulWidget {
  const HealthMetricsScreen({super.key});

  @override
  State<HealthMetricsScreen> createState() => _HealthMetricsScreenState();
}

class _HealthMetricsScreenState extends State<HealthMetricsScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Controllers for manual inputs
  final _heartRateController = TextEditingController();
  final _hrvController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _sleepHoursController = TextEditingController();
  final _spO2Controller = TextEditingController();
  final _temperatureController = TextEditingController();

  // Sweating level (1-10 slider)
  double _sweatingLevel = 5.0;

  // Camera captured data
  String? _facialExpression;
  int? _eyeBlinkRate;
  bool _isCameraDataCaptured = false;

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _heartRateController.dispose();
    _hrvController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _sleepHoursController.dispose();
    _spO2Controller.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateNumber(String? value, String fieldName, int min, int max) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  String? _validateDecimal(String? value, String fieldName, double min, double max) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  // Open camera for facial data capture
  Future<void> _captureFacialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Open camera screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FacialCameraScreen(),
        ),
      );

      if (result != null && result['success'] == true) {
        setState(() {
          _facialExpression = result['facialExpression'];
          _eyeBlinkRate = result['eyeBlinkRate'];
          _isCameraDataCaptured = true;
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Facial data captured successfully!\n'
                'Expression: $_facialExpression | Blink Rate: $_eyeBlinkRate',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture facial data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Submit all health metrics
  Future<void> _submitHealthMetrics() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (!_isCameraDataCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture facial data first'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Send data to backend for stress prediction
    final healthData = {
      'heartRate': int.parse(_heartRateController.text),
      'hrv': int.parse(_hrvController.text),
      'bloodPressure': {
        'systolic': int.parse(_systolicController.text),
        'diastolic': int.parse(_diastolicController.text),
      },
      'sleepHours': double.parse(_sleepHoursController.text),
      'sweatingLevel': _sweatingLevel.round(),
      'spO2': int.parse(_spO2Controller.text),
      'temperature': double.parse(_temperatureController.text),
      'facialExpression': _facialExpression,
      'eyeBlinkRate': _eyeBlinkRate,
    };

    print('Health Data: $healthData');

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Health metrics submitted successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Navigate to results/dashboard screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Health Metrics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Scrollable form section
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true, // Always show scrollbar
              thickness: 6,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Enter Your Health Data',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Provide accurate data for stress detection',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Section 1: Vital Signs
                      _buildSectionHeader('Vital Signs', Icons.favorite),
                      const SizedBox(height: 16),

                      // Heart Rate & HRV in Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _heartRateController,
                              label: 'Heart Rate',
                              hint: 'bpm',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.favorite,
                              validator: (value) =>
                                  _validateNumber(value, 'Heart Rate', 40, 200),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _hrvController,
                              label: 'HRV',
                              hint: 'ms',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.monitor_heart_outlined,
                              validator: (value) =>
                                  _validateNumber(value, 'HRV', 10, 200),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Blood Pressure
                      Text(
                        'Blood Pressure (mmHg)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _systolicController,
                              label: 'Systolic',
                              hint: '120',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  _validateNumber(value, 'Systolic', 70, 200),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _diastolicController,
                              label: 'Diastolic',
                              hint: '80',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  _validateNumber(value, 'Diastolic', 40, 130),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // SpO2 & Sleep Hours in Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _spO2Controller,
                              label: 'SpO2 (%)',
                              hint: '98',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.air,
                              validator: (value) => _validateNumber(value, 'SpO2', 70, 100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _sleepHoursController,
                              label: 'Sleep (hrs)',
                              hint: '7.5',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              prefixIcon: Icons.bedtime,
                              validator: (value) =>
                                  _validateDecimal(value, 'Sleep', 0, 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Temperature
                      CustomTextField(
                        controller: _temperatureController,
                        label: 'Body Temperature (°F)',
                        hint: '98.6',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        prefixIcon: Icons.thermostat,
                        validator: (value) =>
                            _validateDecimal(value, 'Temperature', 95.0, 105.0),
                      ),
                      const SizedBox(height: 24),

                      // Sweating Level Slider
                      _buildSectionHeader('Sweating Level', Icons.water_drop),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Level: ${_sweatingLevel.round()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  _getSweatingLevelText(_sweatingLevel.round()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _getSweatingLevelColor(_sweatingLevel.round()),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _sweatingLevel,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.divider,
                              onChanged: (value) {
                                setState(() {
                                  _sweatingLevel = value;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Low', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                Text('High', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100), // Bottom padding for scrolling
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed bottom section - Camera & Submit
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Camera Section
                    if (!_isCameraDataCaptured)
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _captureFacialData,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.camera_alt),
                        label: Text(_isLoading ? 'Processing...' : 'Capture Facial Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                    // Captured Data Display
                    if (_isCameraDataCaptured) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Facial Data Captured',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '$_facialExpression • ${_eyeBlinkRate} blinks/min',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isCameraDataCaptured = false;
                                  _facialExpression = null;
                                  _eyeBlinkRate = null;
                                });
                              },
                              child: const Text('Retake'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Submit Button
                      CustomButton(
                        text: 'Analyze Stress Level',
                        onPressed: _isLoading ? () {} : _submitHealthMetrics,
                        isLoading: _isLoading,
                        icon: Icons.analytics,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _getSweatingLevelText(int level) {
    if (level <= 3) return 'Low';
    if (level <= 6) return 'Moderate';
    return 'High';
  }

  Color _getSweatingLevelColor(int level) {
    if (level <= 3) return AppColors.success;
    if (level <= 6) return AppColors.warning;
    return AppColors.error;
  }
}