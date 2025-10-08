import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit_model.dart';

/// Repository for managing habit data
/// Handles all Firebase Firestore operations for habits
class HabitRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HabitRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  /// Reference to habits collection
  CollectionReference get _habitsCollection => _firestore.collection('habits');

  /// Stream of habits for the current user
  /// Returns real-time updates whenever habits change
  Stream<List<HabitModel>> getHabitsStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _habitsCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    HabitModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  /// Get all habits for the current user (one-time fetch)
  Future<List<HabitModel>> getHabits() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _habitsCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HabitModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get a single habit by ID
  Future<HabitModel?> getHabitById(String habitId) async {
    final doc = await _habitsCollection.doc(habitId).get();
    if (!doc.exists) return null;
    return HabitModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Add a new habit
  Future<void> addHabit(HabitModel habit) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    // Ensure the habit has the correct userId
    final habitWithUserId = habit.copyWith(userId: _userId!);
    await _habitsCollection
        .doc(habitWithUserId.id)
        .set(habitWithUserId.toJson());
  }

  /// Update an existing habit
  Future<void> updateHabit(HabitModel habit) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _habitsCollection.doc(habit.id).update(habit.toJson());
  }

  /// Delete a habit
  Future<void> deleteHabit(String habitId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _habitsCollection.doc(habitId).delete();
  }

  /// Mark a habit as completed for today
  /// Updates streak information and adds completion date
  Future<void> completeHabit(String habitId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final habit = await getHabitById(habitId);
    if (habit == null) {
      throw Exception('Habit not found');
    }

    // Check if already completed today
    if (habit.isCompletedToday()) {
      throw Exception('Habit already completed today');
    }

    // Calculate new streak
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    bool wasCompletedYesterday = habit.completedDates.any(
      (date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day,
    );

    int newStreak = wasCompletedYesterday ? habit.currentStreak + 1 : 1;
    int newLongestStreak = newStreak > habit.longestStreak
        ? newStreak
        : habit.longestStreak;

    // Add today's completion
    final updatedCompletedDates = [...habit.completedDates, now];

    final updatedHabit = habit.copyWith(
      completedDates: updatedCompletedDates,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      updatedAt: now,
    );

    await updateHabit(updatedHabit);
  }

  /// Toggle habit active status
  Future<void> toggleHabitActive(String habitId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final habit = await getHabitById(habitId);
    if (habit == null) {
      throw Exception('Habit not found');
    }

    final updatedHabit = habit.copyWith(
      isActive: !habit.isActive,
      updatedAt: DateTime.now(),
    );

    await updateHabit(updatedHabit);
  }

  /// Get active habits only
  Future<List<HabitModel>> getActiveHabits() async {
    final habits = await getHabits();
    return habits.where((habit) => habit.isActive).toList();
  }

  /// Get habits completed today
  Future<List<HabitModel>> getHabitsCompletedToday() async {
    final habits = await getHabits();
    return habits.where((habit) => habit.isCompletedToday()).toList();
  }

  /// Get habits by category
  Future<List<HabitModel>> getHabitsByCategory(String category) async {
    final habits = await getHabits();
    return habits.where((habit) => habit.category == category).toList();
  }
}
