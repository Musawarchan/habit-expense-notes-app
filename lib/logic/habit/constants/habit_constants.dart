/// Constants for Habit feature
class HabitConstants {
  // Frequency options
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyMonthly = 'monthly';

  static const List<String> frequencyOptions = [
    frequencyDaily,
    frequencyWeekly,
    frequencyMonthly,
  ];

  // Category options
  static const String categoryHealth = 'Health';
  static const String categoryFitness = 'Fitness';
  static const String categoryProductivity = 'Productivity';
  static const String categoryMindfulness = 'Mindfulness';
  static const String categoryLearning = 'Learning';
  static const String categorySocial = 'Social';
  static const String categoryPersonal = 'Personal';
  static const String categoryOther = 'Other';

  static const List<String> categoryOptions = [
    categoryHealth,
    categoryFitness,
    categoryProductivity,
    categoryMindfulness,
    categoryLearning,
    categorySocial,
    categoryPersonal,
    categoryOther,
  ];

  // Category icons
  static const Map<String, String> categoryIcons = {
    categoryHealth: '🏥',
    categoryFitness: '💪',
    categoryProductivity: '📊',
    categoryMindfulness: '🧘',
    categoryLearning: '📚',
    categorySocial: '👥',
    categoryPersonal: '⭐',
    categoryOther: '📝',
  };

  // Streak milestones
  static const int streakMilestone7 = 7;
  static const int streakMilestone30 = 30;
  static const int streakMilestone100 = 100;
  static const int streakMilestone365 = 365;
}
