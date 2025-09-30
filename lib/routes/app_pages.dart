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
  static const String tasks = '/tasks';
  static const String expenses = '/expenses';
  static const String notes = '/notes';
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
  static Widget tasksPage() => const TasksScreen();
  static Widget expensesPage() => const ExpensesScreen();
  static Widget notesPage() => const NotesScreen();
  static Widget aiPage() => const AiScreen();
  static Widget settingsPage() => const SettingsScreen();
  static Widget profileEditPage() => const ProfileEditScreen();
  static Widget onboardingPage() => const OnboardingScreen();
}
