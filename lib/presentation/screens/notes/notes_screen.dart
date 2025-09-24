import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notes),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add note
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Notes Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Capture your thoughts and ideas',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add note
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
