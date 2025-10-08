import 'package:equatable/equatable.dart';
import '../models/expense_model.dart';

/// Base class for all Expense events
/// Uses Equatable for value equality comparison
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all expenses for the current user
class ExpenseLoadRequested extends ExpenseEvent {
  const ExpenseLoadRequested();
}

/// Event to add a new expense
class ExpenseAddRequested extends ExpenseEvent {
  final ExpenseModel expense;

  const ExpenseAddRequested({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Event to update an existing expense
class ExpenseUpdateRequested extends ExpenseEvent {
  final ExpenseModel expense;

  const ExpenseUpdateRequested({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Event to delete an expense
class ExpenseDeleteRequested extends ExpenseEvent {
  final String expenseId;

  const ExpenseDeleteRequested({required this.expenseId});

  @override
  List<Object?> get props => [expenseId];
}

/// Event to filter expenses by date range
class ExpenseFilterByDateRequested extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseFilterByDateRequested({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to filter expenses by category
class ExpenseFilterByCategoryRequested extends ExpenseEvent {
  final String? category;

  const ExpenseFilterByCategoryRequested({this.category});

  @override
  List<Object?> get props => [category];
}

/// Event when expense list changes (from Firestore stream)
class ExpenseListChanged extends ExpenseEvent {
  final List<ExpenseModel> expenses;

  const ExpenseListChanged({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}
