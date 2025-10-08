import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlife_app/presentation/screens/expenses/expenses_screen.dart';
import 'package:smartlife_app/presentation/screens/habits/habits_screen.dart';
import 'package:smartlife_app/presentation/screens/notes/notes_screen.dart';
import 'package:smartlife_app/presentation/screens/tasks/tasks_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../widgets/custom_widgets.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/services/dialog_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const HabitsScreen(),
    const TasksScreen(),
    const ExpensesScreen(),
    const NotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: AppStrings.habits,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: AppStrings.tasks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: AppStrings.expenses,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: AppStrings.notes,
          ),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(context),
    );
  }

  /// Get the appropriate floating action button based on current tab
  Widget _getFloatingActionButton(BuildContext context) {
    switch (_currentIndex) {
      case 0: // Dashboard
        return FloatingActionButton(
          onPressed: () {
            context.go(AppPages.ai);
          },
          child: const Icon(Icons.psychology),
        );
      case 1: // Habits
        return FloatingActionButton(
          onPressed: () {
            DialogService.showAddHabitDialog(context);
          },
          child: const Icon(Icons.add),
        );
      case 2: // Tasks
        return FloatingActionButton(
          onPressed: () {
            DialogService.showAddTaskDialog(context);
          },
          child: const Icon(Icons.add),
        );
      case 3: // Expenses
        return FloatingActionButton(
          onPressed: () {
            DialogService.showAddExpenseDialog(context);
          },
          child: const Icon(Icons.add),
        );
      case 4: // Notes
        return FloatingActionButton(
          onPressed: () {
            DialogService.showAddNoteDialog(context);
          },
          child: const Icon(Icons.add),
        );
      default:
        return FloatingActionButton(
          onPressed: () {
            context.go(AppPages.ai);
          },
          child: const Icon(Icons.psychology),
        );
    }
  }
}

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  void initState() {
    super.initState();
    _ensureUserHasLatestFcm();
  }

  Future<void> _ensureUserHasLatestFcm() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('device_fcm_token');
      if (token == null || token.isEmpty) return;
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await ref.set({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go(AppPages.settings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to make today productive?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Today\'s Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Habits',
                    value: '3/5',
                    icon: Icons.track_changes,
                    color: AppColors.habitColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Tasks',
                    value: '7/10',
                    icon: Icons.task,
                    color: AppColors.taskColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Expenses',
                    value: '\$45.50',
                    icon: Icons.attach_money,
                    color: AppColors.expenseColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Notes',
                    value: '2',
                    icon: Icons.note,
                    color: AppColors.noteColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// class _QuickActionCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _QuickActionCard({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomCard(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, size: 32, color: color),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
