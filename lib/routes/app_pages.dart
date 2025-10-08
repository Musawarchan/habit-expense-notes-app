import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/habits/habits_screen.dart';
import '../presentation/screens/tasks/tasks_screen.dart';
import '../presentation/screens/expenses/expenses_screen.dart';
import '../presentation/screens/notes/notes_screen.dart';
import '../presentation/screens/ai/ai_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/edit_profile/profile_edit_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';

class AppPages {
  // Auth Pages
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Main Pages
  static const String home = '/home';
  static const String habits = '/habits';
  static const String addHabit = '/add-habit';
  static const String tasks = '/tasks';
  static const String addTask = '/add-task';
  static const String expenses = '/expenses';
  static const String addExpense = '/add-expense';
  static const String notes = '/notes';
  static const String addNote = '/add-note';
  static const String ai = '/ai';
  static const String settings = '/settings';
  static const String profileEdit = '/profile-edit';
  static const String onboarding = '/onboarding';

  // Page Widgets
  static Widget splashPage() => const SplashScreen();
  static Widget loginPage() => const LoginScreen();
  static Widget registerPage() => const RegisterScreen();
  static Widget homePage() => const HomeScreen();
  static Widget habitsPage() => const HabitsScreen();
  static Widget addHabitPage() => const _PlaceholderScreen('Add Habit');
  static Widget tasksPage() => const TasksScreen();
  static Widget addTaskPage() => const _PlaceholderScreen('Add Task');
  static Widget expensesPage() => const ExpensesScreen();
  static Widget addExpensePage() => const _PlaceholderScreen('Add Expense');
  static Widget notesPage() => const NotesScreen();
  static Widget addNotePage() => const _PlaceholderScreen('Add Note');
  static Widget aiPage() => const AiScreen();
  static Widget settingsPage() => const SettingsScreen();
  static Widget profileEditPage() => const ProfileEditScreen();
  static Widget onboardingPage() => const OnboardingScreen();
}

// Placeholder screen for add functionality
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Feature',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
