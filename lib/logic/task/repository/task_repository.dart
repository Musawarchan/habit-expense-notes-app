import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

/// Repository for managing task data
/// Handles all Firebase Firestore operations for tasks
class TaskRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  /// Reference to tasks collection
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// Stream of tasks for the current user
  /// Returns real-time updates whenever tasks change
  Stream<List<TaskModel>> getTasksStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _tasksCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  /// Get all tasks for the current user (one-time fetch)
  Future<List<TaskModel>> getTasks() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _tasksCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get a single task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    final doc = await _tasksCollection.doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Add a new task
  Future<void> addTask(TaskModel task) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    // Ensure the task has the correct userId
    final taskWithUserId = task.copyWith(userId: _userId!);
    await _tasksCollection.doc(taskWithUserId.id).set(taskWithUserId.toJson());
  }

  /// Update an existing task
  Future<void> updateTask(TaskModel task) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _tasksCollection.doc(task.id).update(task.toJson());
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _tasksCollection.doc(taskId).delete();
  }

  /// Mark a task as completed
  Future<void> completeTask(String taskId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final task = await getTaskById(taskId);
    if (task == null) {
      throw Exception('Task not found');
    }

    final updatedTask = task.copyWith(
      status: 'completed',
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await updateTask(updatedTask);
  }

  /// Update task status
  Future<void> updateTaskStatus(String taskId, String status) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final task = await getTaskById(taskId);
    if (task == null) {
      throw Exception('Task not found');
    }

    final updatedTask = task.copyWith(
      status: status,
      completedAt: status == 'completed' ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );

    await updateTask(updatedTask);
  }

  /// Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.status == status).toList();
  }

  /// Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.category == category).toList();
  }

  /// Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    final tasks = await getTasks();
    return tasks.where((task) => task.isOverdue).toList();
  }

  /// Get tasks due today
  Future<List<TaskModel>> getTasksDueToday() async {
    final tasks = await getTasks();
    return tasks.where((task) => task.isDueToday).toList();
  }

  /// Get pending tasks
  Future<List<TaskModel>> getPendingTasks() async {
    return getTasksByStatus('pending');
  }

  /// Get in-progress tasks
  Future<List<TaskModel>> getInProgressTasks() async {
    return getTasksByStatus('in_progress');
  }

  /// Get completed tasks
  Future<List<TaskModel>> getCompletedTasks() async {
    return getTasksByStatus('completed');
  }
}
