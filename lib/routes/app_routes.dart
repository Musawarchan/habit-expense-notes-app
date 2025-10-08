import 'package:go_router/go_router.dart';
import 'app_pages.dart';

class AppRoutes {
  static GoRouter get router => GoRouter(
    initialLocation: AppPages.splash,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppPages.splash,
        builder: (context, state) => AppPages.splashPage(),
      ),
      GoRoute(
        path: AppPages.login,
        builder: (context, state) => AppPages.loginPage(),
      ),
      GoRoute(
        path: AppPages.register,
        builder: (context, state) => AppPages.registerPage(),
      ),

      // Main Routes
      GoRoute(
        path: AppPages.home,
        builder: (context, state) => AppPages.homePage(),
      ),
      GoRoute(
        path: AppPages.habits,
        builder: (context, state) => AppPages.habitsPage(),
      ),
      GoRoute(
        path: AppPages.addHabit,
        builder: (context, state) => AppPages.addHabitPage(),
      ),
      GoRoute(
        path: AppPages.tasks,
        builder: (context, state) => AppPages.tasksPage(),
      ),
      GoRoute(
        path: AppPages.addTask,
        builder: (context, state) => AppPages.addTaskPage(),
      ),
      GoRoute(
        path: AppPages.expenses,
        builder: (context, state) => AppPages.expensesPage(),
      ),
      GoRoute(
        path: AppPages.addExpense,
        builder: (context, state) => AppPages.addExpensePage(),
      ),
      GoRoute(
        path: AppPages.notes,
        builder: (context, state) => AppPages.notesPage(),
      ),
      GoRoute(
        path: AppPages.addNote,
        builder: (context, state) => AppPages.addNotePage(),
      ),
      GoRoute(
        path: AppPages.ai,
        builder: (context, state) => AppPages.aiPage(),
      ),
      GoRoute(
        path: AppPages.settings,
        builder: (context, state) => AppPages.settingsPage(),
      ),
      GoRoute(
        path: AppPages.profileEdit,
        builder: (context, state) => AppPages.profileEditPage(),
      ),
      GoRoute(
        path: AppPages.onboarding,
        builder: (context, state) => AppPages.onboardingPage(),
      ),
    ],
  );
}
