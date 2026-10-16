/// All text strings used in the app
/// Centralized for easy translation and maintenance
class AppStrings {
  // App Info
  static const String appName = 'StressLess';
  static const String appTagline = 'Your Mental Wellness Companion';

  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String age = 'Age';
  static const String gender = 'Gender';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';

  // Home Screen
  static const String welcome = 'Welcome';
  static const String howAreYouFeeling = 'How are you feeling today?';
  static const String takeAssessment = 'Take Assessment';
  static const String viewHistory = 'View History';
  static const String yourProgress = 'Your Progress';
  static const String recentResults = 'Recent Results';

  // Health Metrics Input
  static const String healthMetrics = 'Health Metrics';
  static const String enterMetrics = 'Enter Your Health Data';
  static const String heartRate = 'Heart Rate (bpm)';
  static const String heartRateVariability = 'Heart Rate Variability (ms)';
  static const String bloodPressure = 'Blood Pressure';
  static const String systolic = 'Systolic';
  static const String diastolic = 'Diastolic';
  static const String sleepHours = 'Sleep Hours';
  static const String sweatingLevel = 'Sweating Level (1-10)';
  static const String spO2 = 'SpO2 (%)';
  static const String facialExpression = 'Facial Expression';
  static const String eyeBlinkRate = 'Eye Blink Rate (per min)';

  // Questionnaire
  static const String stressAssessment = 'Stress Assessment';
  static const String questionProgress = 'Question';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String submit = 'Submit';
  static const String pleaseAnswer = 'Please answer all questions';

  // Question Options (PSS-10 Scale)
  static const String never = 'Never';
  static const String rarely = 'Rarely';
  static const String sometimes = 'Sometimes';
  static const String often = 'Often';
  static const String veryOften = 'Very Often';

  // Results
  static const String yourStressLevel = 'Your Stress Level';
  static const String stressLevelLow = 'Low';
  static const String stressLevelModerate = 'Moderate';
  static const String stressLevelHigh = 'High';
  static const String recommendations = 'Recommendations';
  static const String viewDetailedReport = 'View Detailed Report';
  static const String saveToHistory = 'Save to History';

  // Recommendations
  static const String lowStressRec1 = 'Maintain your current healthy habits';
  static const String lowStressRec2 =
      'Continue regular exercise and sleep routine';
  static const String lowStressRec3 = 'Practice mindfulness meditation daily';

  static const String moderateStressRec1 = 'Take regular breaks during work';
  static const String moderateStressRec2 = 'Practice deep breathing exercises';
  static const String moderateStressRec3 =
      'Consider talking to a friend or counselor';
  static const String moderateStressRec4 = 'Ensure 7-8 hours of quality sleep';

  static const String highStressRec1 = 'Consult a mental health professional';
  static const String highStressRec2 =
      'Reduce workload and commitments if possible';
  static const String highStressRec3 = 'Practice relaxation techniques daily';
  static const String highStressRec4 = 'Engage in physical activity regularly';
  static const String highStressRec5 = 'Avoid caffeine and alcohol';

  // History
  static const String history = 'History';
  static const String stressHistory = 'Stress History';
  static const String noHistoryYet = 'No history available yet';
  static const String takeFirstAssessment =
      'Take your first assessment to see results here';

  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String darkMode = 'Dark Mode';
  static const String about = 'About';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';

  // Messages
  static const String loading = 'Loading...';
  static const String processingData = 'Processing your data...';
  static const String analyzingStress = 'Analyzing your stress level...';
  static const String success = 'Success';
  static const String error = 'Error';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';

  // Error Messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Invalid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';
  static const String ageRequired = 'Age is required';
  static const String genderRequired = 'Gender is required';
  static const String loginFailed =
      'Login failed. Please check your credentials';
  static const String registrationFailed =
      'Registration failed. Please try again';
  static const String networkError =
      'Network error. Please check your connection';
  static const String serverError = 'Server error. Please try again later';

  // PSS-10 Questions (Perceived Stress Scale)
  static const List<String> questions = [
    'In the last month, how often have you been upset because of something that happened unexpectedly?',
    'In the last month, how often have you felt that you were unable to control the important things in your life?',
    'In the last month, how often have you felt nervous and stressed?',
    'In the last month, how often have you felt confident about your ability to handle your personal problems?',
    'In the last month, how often have you felt that things were going your way?',
    'In the last month, how often have you found that you could not cope with all the things that you had to do?',
    'In the last month, how often have you been able to control irritations in your life?',
    'In the last month, how often have you felt that you were on top of things?',
    'In the last month, how often have you been angered because of things that were outside of your control?',
    'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?',
  ];
}
