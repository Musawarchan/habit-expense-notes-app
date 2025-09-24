class AppConstants {
  // App Info
  static const String appName = 'SmartLife';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String habitsCollection = 'habits';
  static const String tasksCollection = 'tasks';
  static const String expensesCollection = 'expenses';
  static const String notesCollection = 'notes';
  static const String aiMessagesCollection = 'ai_messages';
  static const String analyticsCollection = 'analytics';

  // Hive Box Names
  static const String userBox = 'user_box';
  static const String habitsBox = 'habits_box';
  static const String tasksBox = 'tasks_box';
  static const String expensesBox = 'expenses_box';
  static const String notesBox = 'notes_box';
  static const String settingsBox = 'settings_box';

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String backgroundImageKey = 'background_image';
  static const String userIdKey = 'user_id';
  static const String lastSyncKey = 'last_sync';

  // Gemini API
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  static const String geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Notification IDs
  static const int habitReminderId = 1000;
  static const int taskReminderId = 2000;
  static const int expenseReminderId = 3000;

  // Default Values
  static const double defaultBudgetLimit = 1000.0;
  static const int defaultHabitStreak = 0;
  static const int maxHabitStreak = 365;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
}
