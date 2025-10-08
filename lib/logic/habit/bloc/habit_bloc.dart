import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'habit_event.dart';
import 'habit_state.dart';
import '../repository/habit_repository.dart';
import '../models/habit_model.dart';

/// BLoC for managing habit state and business logic
/// Handles all habit-related events and emits appropriate states
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _habitRepository;
  StreamSubscription<List<HabitModel>>? _habitsSubscription;

  HabitBloc({required HabitRepository habitRepository})
    : _habitRepository = habitRepository,
      super(const HabitInitial()) {
    // Register event handlers
    on<HabitLoadRequested>(_onLoadRequested);
    on<HabitAddRequested>(_onAddRequested);
    on<HabitUpdateRequested>(_onUpdateRequested);
    on<HabitDeleteRequested>(_onDeleteRequested);
    on<HabitCompleteRequested>(_onCompleteRequested);
    on<HabitToggleActiveRequested>(_onToggleActiveRequested);
    on<HabitListChanged>(_onListChanged);
  }

  /// Handle habit load request
  /// Sets up real-time listener for habit changes
  Future<void> _onLoadRequested(
    HabitLoadRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      emit(const HabitLoading());

      // Cancel existing subscription if any
      await _habitsSubscription?.cancel();

      // Subscribe to habits stream
      _habitsSubscription = _habitRepository.getHabitsStream().listen(
        (habits) => add(HabitListChanged(habits: habits)),
      );
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  /// Handle habit add request
  Future<void> _onAddRequested(
    HabitAddRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.addHabit(event.habit);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(HabitError(message: 'Failed to add habit: ${e.toString()}'));
    }
  }

  /// Handle habit update request
  Future<void> _onUpdateRequested(
    HabitUpdateRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.updateHabit(event.habit);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(HabitError(message: 'Failed to update habit: ${e.toString()}'));
    }
  }

  /// Handle habit delete request
  Future<void> _onDeleteRequested(
    HabitDeleteRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.deleteHabit(event.habitId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(HabitError(message: 'Failed to delete habit: ${e.toString()}'));
    }
  }

  /// Handle habit complete request
  Future<void> _onCompleteRequested(
    HabitCompleteRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.completeHabit(event.habitId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(HabitError(message: e.toString()));
    }
  }

  /// Handle habit toggle active request
  Future<void> _onToggleActiveRequested(
    HabitToggleActiveRequested event,
    Emitter<HabitState> emit,
  ) async {
    try {
      await _habitRepository.toggleHabitActive(event.habitId);
      emit(const HabitOperationSuccess(message: 'Habit status updated'));
    } catch (e) {
      emit(HabitError(message: 'Failed to toggle habit: ${e.toString()}'));
    }
  }

  /// Handle habit list changes from Firestore stream
  /// Processes the list and categorizes habits
  void _onListChanged(HabitListChanged event, Emitter<HabitState> emit) {
    final habits = event.habits;
    final activeHabits = habits.where((h) => h.isActive).toList();
    final completedTodayHabits = habits
        .where((h) => h.isCompletedToday())
        .toList();

    emit(
      HabitLoaded(
        habits: habits,
        activeHabits: activeHabits,
        completedTodayHabits: completedTodayHabits,
      ),
    );
  }

  @override
  Future<void> close() {
    _habitsSubscription?.cancel();
    return super.close();
  }
}
