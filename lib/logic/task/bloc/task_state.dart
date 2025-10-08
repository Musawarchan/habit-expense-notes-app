import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

/// Base class for all Task states
/// Uses Equatable for value equality comparison
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any tasks are loaded
class TaskInitial extends TaskState {
  const TaskInitial();
}

/// State when tasks are being loaded
class TaskLoading extends TaskState {
  const TaskLoading();
}

/// State when tasks are successfully loaded
class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final List<TaskModel> pendingTasks;
  final List<TaskModel> inProgressTasks;
  final List<TaskModel> completedTasks;
  final List<TaskModel> overdueTasks;
  final String? filterStatus;
  final String? filterPriority;
  final String? filterCategory;

  const TaskLoaded({
    required this.tasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completedTasks,
    required this.overdueTasks,
    this.filterStatus,
    this.filterPriority,
    this.filterCategory,
  });

  @override
  List<Object?> get props => [
    tasks,
    pendingTasks,
    inProgressTasks,
    completedTasks,
    overdueTasks,
    filterStatus,
    filterPriority,
    filterCategory,
  ];

  /// Get filtered tasks based on current filters
  List<TaskModel> get filteredTasks {
    var filtered = tasks;

    if (filterStatus != null) {
      filtered = filtered.where((t) => t.status == filterStatus).toList();
    }

    if (filterPriority != null) {
      filtered = filtered.where((t) => t.priority == filterPriority).toList();
    }

    if (filterCategory != null) {
      filtered = filtered.where((t) => t.category == filterCategory).toList();
    }

    return filtered;
  }

  /// Calculate statistics
  int get totalTasks => tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;
  int get overdueCount => overdueTasks.length;
  double get completionRate =>
      totalTasks > 0 ? completedCount / totalTasks : 0.0;

  /// Copy with new filters
  TaskLoaded copyWithFilters({
    String? filterStatus,
    String? filterPriority,
    String? filterCategory,
  }) {
    return TaskLoaded(
      tasks: tasks,
      pendingTasks: pendingTasks,
      inProgressTasks: inProgressTasks,
      completedTasks: completedTasks,
      overdueTasks: overdueTasks,
      filterStatus: filterStatus,
      filterPriority: filterPriority,
      filterCategory: filterCategory,
    );
  }
}

/// State when a task operation (add/update/delete) is in progress
class TaskOperationInProgress extends TaskState {
  final List<TaskModel> tasks; // Keep existing tasks during operation

  const TaskOperationInProgress({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

/// State when a task operation succeeds
class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when an error occurs
class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}
