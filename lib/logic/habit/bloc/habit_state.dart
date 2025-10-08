import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

/// Base class for all Habit states
/// Uses Equatable for value equality comparison
abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any habits are loaded
class HabitInitial extends HabitState {
  const HabitInitial();
}

/// State when habits are being loaded
class HabitLoading extends HabitState {
  const HabitLoading();
}

/// State when habits are successfully loaded
class HabitLoaded extends HabitState {
  final List<HabitModel> habits;
  final List<HabitModel> activeHabits;
  final List<HabitModel> completedTodayHabits;

  const HabitLoaded({
    required this.habits,
    required this.activeHabits,
    required this.completedTodayHabits,
  });

  @override
  List<Object?> get props => [habits, activeHabits, completedTodayHabits];

  /// Calculate statistics for display
  int get totalHabits => habits.length;
  int get activeHabitsCount => activeHabits.length;
  int get completedTodayCount => completedTodayHabits.length;
  double get completionRate =>
      activeHabitsCount > 0 ? completedTodayCount / activeHabitsCount : 0.0;
}

/// State when a habit operation (add/update/delete) is in progress
class HabitOperationInProgress extends HabitState {
  final List<HabitModel> habits; // Keep existing habits during operation

  const HabitOperationInProgress({required this.habits});

  @override
  List<Object?> get props => [habits];
}

/// State when a habit operation succeeds
class HabitOperationSuccess extends HabitState {
  final String message;

  const HabitOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when an error occurs
class HabitError extends HabitState {
  final String message;

  const HabitError({required this.message});

  @override
  List<Object?> get props => [message];
}
