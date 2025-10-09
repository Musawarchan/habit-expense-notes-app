import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../../../logic/habit/bloc/habit_bloc.dart';
import '../../../logic/habit/bloc/habit_event.dart';
import '../../../logic/habit/bloc/habit_state.dart';
import '../../../logic/habit/models/habit_model.dart';
import '../../../logic/habit/constants/habit_constants.dart';

/// Screen for managing habits
/// Displays list of habits with completion tracking and streak information
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.habits),

        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is HabitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HabitLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HabitLoaded) {
            if (state.habits.isEmpty) {
              return _buildEmptyState(context);
            }

            return Column(
              children: [
                _buildStatisticsCard(context, state),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.activeHabits.length,
                    itemBuilder: (context, index) {
                      return _buildHabitCard(
                        context,
                        state.activeHabits[index],
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build empty state when no habits exist
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.track_changes, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Habits Yet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start building positive habits today!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddHabitDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Habit'),
          ),
        ],
      ),
    );
  }

  /// Build statistics card showing habit overview
  Widget _buildStatisticsCard(BuildContext context, HabitLoaded state) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Total',
              state.totalHabits.toString(),
              Icons.format_list_bulleted,
              Colors.blue,
            ),
            _buildStatItem(
              'Active',
              state.activeHabitsCount.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatItem(
              'Today',
              state.completedTodayCount.toString(),
              Icons.today,
              Colors.orange,
            ),
            _buildStatItem(
              'Rate',
              '${(state.completionRate * 100).toInt()}%',
              Icons.trending_up,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  /// Build habit card
  Widget _buildHabitCard(BuildContext context, HabitModel habit) {
    final isCompleted = habit.isCompletedToday();
    final completionPercentage = habit.getCompletionPercentage();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showHabitDetailsDialog(context, habit),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    HabitConstants.categoryIcons[habit.category] ?? '📝',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (habit.description.isNotEmpty)
                          Text(
                            habit.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompleted ? Colors.green : Colors.grey,
                      size: 32,
                    ),
                    onPressed: isCompleted
                        ? null
                        : () {
                            context.read<HabitBloc>().add(
                              HabitCompleteRequested(habitId: habit.id),
                            );
                          },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: completionPercentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak} day streak',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    habit.frequency.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show add habit dialog
  void _showAddHabitDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = HabitConstants.categoryPersonal;
    String selectedFrequency = HabitConstants.frequencyDaily;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Habit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: HabitConstants.categoryOptions.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      '${HabitConstants.categoryIcons[category]} $category',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedCategory = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: HabitConstants.frequencyOptions.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedFrequency = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a habit name')),
                );
                return;
              }

              final habit = HabitModel(
                id: const Uuid().v4(),
                userId: 'current_user', // Will be set by repository
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                category: selectedCategory,
                frequency: selectedFrequency,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              context.read<HabitBloc>().add(HabitAddRequested(habit: habit));
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Show habit details dialog
  void _showHabitDetailsDialog(BuildContext context, HabitModel habit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(habit.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (habit.description.isNotEmpty) ...[
              Text(habit.description),
              const SizedBox(height: 16),
            ],
            _buildDetailRow('Category', habit.category),
            _buildDetailRow('Frequency', habit.frequency.toUpperCase()),
            _buildDetailRow('Current Streak', '${habit.currentStreak} days'),
            _buildDetailRow('Longest Streak', '${habit.longestStreak} days'),
            _buildDetailRow(
              'Total Completions',
              '${habit.completedDates.length}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<HabitBloc>().add(
                HabitDeleteRequested(habitId: habit.id),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build detail row for habit details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filter Habits'),
        content: const Text('Filter functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
