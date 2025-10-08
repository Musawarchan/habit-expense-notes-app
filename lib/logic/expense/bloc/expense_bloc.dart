import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../repository/expense_repository.dart';
import '../models/expense_model.dart';

/// BLoC for managing expense state and business logic
/// Handles all expense-related events and emits appropriate states
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _expenseRepository;
  StreamSubscription<List<ExpenseModel>>? _expensesSubscription;

  ExpenseBloc({required ExpenseRepository expenseRepository})
    : _expenseRepository = expenseRepository,
      super(const ExpenseInitial()) {
    // Register event handlers
    on<ExpenseLoadRequested>(_onLoadRequested);
    on<ExpenseAddRequested>(_onAddRequested);
    on<ExpenseUpdateRequested>(_onUpdateRequested);
    on<ExpenseDeleteRequested>(_onDeleteRequested);
    on<ExpenseFilterByDateRequested>(_onFilterByDateRequested);
    on<ExpenseFilterByCategoryRequested>(_onFilterByCategoryRequested);
    on<ExpenseListChanged>(_onListChanged);
  }

  /// Handle expense load request
  /// Sets up real-time listener for expense changes
  Future<void> _onLoadRequested(
    ExpenseLoadRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(const ExpenseLoading());

      // Cancel existing subscription if any
      await _expensesSubscription?.cancel();

      // Subscribe to expenses stream
      _expensesSubscription = _expenseRepository.getExpensesStream().listen(
        (expenses) => add(ExpenseListChanged(expenses: expenses)),
      );
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  /// Handle expense add request
  Future<void> _onAddRequested(
    ExpenseAddRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.addExpense(event.expense);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(ExpenseError(message: 'Failed to add expense: ${e.toString()}'));
    }
  }

  /// Handle expense update request
  Future<void> _onUpdateRequested(
    ExpenseUpdateRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.updateExpense(event.expense);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(ExpenseError(message: 'Failed to update expense: ${e.toString()}'));
    }
  }

  /// Handle expense delete request
  Future<void> _onDeleteRequested(
    ExpenseDeleteRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.deleteExpense(event.expenseId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(ExpenseError(message: 'Failed to delete expense: ${e.toString()}'));
    }
  }

  /// Handle filter by date request
  void _onFilterByDateRequested(
    ExpenseFilterByDateRequested event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      emit(
        currentState.copyWithFilters(
          filterStartDate: event.startDate,
          filterEndDate: event.endDate,
        ),
      );
    }
  }

  /// Handle filter by category request
  void _onFilterByCategoryRequested(
    ExpenseFilterByCategoryRequested event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      emit(currentState.copyWithFilters(filterCategory: event.category));
    }
  }

  /// Handle expense list changes from Firestore stream
  /// Processes the list and categorizes expenses
  void _onListChanged(ExpenseListChanged event, Emitter<ExpenseState> emit) {
    final expenses = event.expenses;
    final todayExpenses = expenses.where((e) => e.isToday).toList();
    final weekExpenses = expenses.where((e) => e.isThisWeek).toList();
    final monthExpenses = expenses.where((e) => e.isThisMonth).toList();

    // Calculate category totals
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    emit(
      ExpenseLoaded(
        expenses: expenses,
        todayExpenses: todayExpenses,
        weekExpenses: weekExpenses,
        monthExpenses: monthExpenses,
        categoryTotals: categoryTotals,
      ),
    );
  }

  @override
  Future<void> close() {
    _expensesSubscription?.cancel();
    return super.close();
  }
}
