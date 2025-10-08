import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

/// Base class for all Habit events
/// Uses Equatable for value equality comparison
abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all habits for the current user
class HabitLoadRequested extends HabitEvent {
  const HabitLoadRequested();
}

/// Event to add a new habit
class HabitAddRequested extends HabitEvent {
  final HabitModel habit;

  const HabitAddRequested({required this.habit});

  @override
  List<Object?> get props => [habit];
}

/// Event to update an existing habit
class HabitUpdateRequested extends HabitEvent {
  final HabitModel habit;

  const HabitUpdateRequested({required this.habit});

  @override
  List<Object?> get props => [habit];
}

/// Event to delete a habit
class HabitDeleteRequested extends HabitEvent {
  final String habitId;

  const HabitDeleteRequested({required this.habitId});

  @override
  List<Object?> get props => [habitId];
}

/// Event to mark a habit as completed for today
class HabitCompleteRequested extends HabitEvent {
  final String habitId;

  const HabitCompleteRequested({required this.habitId});

  @override
  List<Object?> get props => [habitId];
}

/// Event to toggle habit active status
class HabitToggleActiveRequested extends HabitEvent {
  final String habitId;

  const HabitToggleActiveRequested({required this.habitId});

  @override
  List<Object?> get props => [habitId];
}

/// Event when habit list changes (from Firestore stream)
class HabitListChanged extends HabitEvent {
  final List<HabitModel> habits;

  const HabitListChanged({required this.habits});

  @override
  List<Object?> get props => [habits];
}
