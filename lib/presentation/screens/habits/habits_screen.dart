import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.habits),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add habit
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.track_changes, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Habits Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Track your daily habits and build streaks',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add habit
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
