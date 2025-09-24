import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.expenses),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add expense
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_money, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Expenses Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Track your expenses and manage your budget',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
