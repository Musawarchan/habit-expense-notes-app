import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

/// Base class for all Task events
/// Uses Equatable for value equality comparison
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks for the current user
class TaskLoadRequested extends TaskEvent {
  const TaskLoadRequested();
}

/// Event to add a new task
class TaskAddRequested extends TaskEvent {
  final TaskModel task;

  const TaskAddRequested({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event to update an existing task
class TaskUpdateRequested extends TaskEvent {
  final TaskModel task;

  const TaskUpdateRequested({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class TaskDeleteRequested extends TaskEvent {
  final String taskId;

  const TaskDeleteRequested({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

/// Event to mark task as completed
class TaskCompleteRequested extends TaskEvent {
  final String taskId;

  const TaskCompleteRequested({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

/// Event to update task status
class TaskStatusUpdateRequested extends TaskEvent {
  final String taskId;
  final String status;

  const TaskStatusUpdateRequested({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}

/// Event to filter tasks
class TaskFilterChanged extends TaskEvent {
  final String? status;
  final String? priority;
  final String? category;

  const TaskFilterChanged({this.status, this.priority, this.category});

  @override
  List<Object?> get props => [status, priority, category];
}

/// Event when task list changes (from Firestore stream)
class TaskListChanged extends TaskEvent {
  final List<TaskModel> tasks;

  const TaskListChanged({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}
