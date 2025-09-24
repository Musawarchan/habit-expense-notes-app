import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add task
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tasks Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your tasks and stay organized',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
