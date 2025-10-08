import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../repository/task_repository.dart';
import '../models/task_model.dart';

/// BLoC for managing task state and business logic
/// Handles all task-related events and emits appropriate states
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  TaskBloc({required TaskRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TaskInitial()) {
    // Register event handlers
    on<TaskLoadRequested>(_onLoadRequested);
    on<TaskAddRequested>(_onAddRequested);
    on<TaskUpdateRequested>(_onUpdateRequested);
    on<TaskDeleteRequested>(_onDeleteRequested);
    on<TaskCompleteRequested>(_onCompleteRequested);
    on<TaskStatusUpdateRequested>(_onStatusUpdateRequested);
    on<TaskFilterChanged>(_onFilterChanged);
    on<TaskListChanged>(_onListChanged);
  }

  /// Handle task load request
  /// Sets up real-time listener for task changes
  Future<void> _onLoadRequested(
    TaskLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(const TaskLoading());

      // Cancel existing subscription if any
      await _tasksSubscription?.cancel();

      // Subscribe to tasks stream
      _tasksSubscription = _taskRepository.getTasksStream().listen(
        (tasks) => add(TaskListChanged(tasks: tasks)),
      );
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle task add request
  Future<void> _onAddRequested(
    TaskAddRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.addTask(event.task);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(TaskError(message: 'Failed to add task: ${e.toString()}'));
    }
  }

  /// Handle task update request
  Future<void> _onUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTask(event.task);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(TaskError(message: 'Failed to update task: ${e.toString()}'));
    }
  }

  /// Handle task delete request
  Future<void> _onDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.deleteTask(event.taskId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(TaskError(message: 'Failed to delete task: ${e.toString()}'));
    }
  }

  /// Handle task complete request
  Future<void> _onCompleteRequested(
    TaskCompleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.completeTask(event.taskId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle task status update request
  Future<void> _onStatusUpdateRequested(
    TaskStatusUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTaskStatus(event.taskId, event.status);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(TaskError(message: 'Failed to update status: ${e.toString()}'));
    }
  }

  /// Handle filter change
  void _onFilterChanged(TaskFilterChanged event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(
        currentState.copyWithFilters(
          filterStatus: event.status,
          filterPriority: event.priority,
          filterCategory: event.category,
        ),
      );
    }
  }

  /// Handle task list changes from Firestore stream
  /// Processes the list and categorizes tasks
  void _onListChanged(TaskListChanged event, Emitter<TaskState> emit) {
    final tasks = event.tasks;
    final pendingTasks = tasks.where((t) => t.status == 'pending').toList();
    final inProgressTasks = tasks
        .where((t) => t.status == 'in_progress')
        .toList();
    final completedTasks = tasks.where((t) => t.status == 'completed').toList();
    final overdueTasks = tasks.where((t) => t.isOverdue).toList();

    emit(
      TaskLoaded(
        tasks: tasks,
        pendingTasks: pendingTasks,
        inProgressTasks: inProgressTasks,
        completedTasks: completedTasks,
        overdueTasks: overdueTasks,
      ),
    );
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
