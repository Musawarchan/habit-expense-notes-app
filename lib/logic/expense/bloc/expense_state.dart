import 'package:equatable/equatable.dart';
import '../models/expense_model.dart';

/// Base class for all Expense states
/// Uses Equatable for value equality comparison
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any expenses are loaded
class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

/// State when expenses are being loaded
class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

/// State when expenses are successfully loaded
class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  final List<ExpenseModel> todayExpenses;
  final List<ExpenseModel> weekExpenses;
  final List<ExpenseModel> monthExpenses;
  final Map<String, double> categoryTotals;
  final String? filterCategory;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const ExpenseLoaded({
    required this.expenses,
    required this.todayExpenses,
    required this.weekExpenses,
    required this.monthExpenses,
    required this.categoryTotals,
    this.filterCategory,
    this.filterStartDate,
    this.filterEndDate,
  });

  @override
  List<Object?> get props => [
    expenses,
    todayExpenses,
    weekExpenses,
    monthExpenses,
    categoryTotals,
    filterCategory,
    filterStartDate,
    filterEndDate,
  ];

  /// Get filtered expenses based on current filters
  List<ExpenseModel> get filteredExpenses {
    var filtered = expenses;

    if (filterCategory != null) {
      filtered = filtered.where((e) => e.category == filterCategory).toList();
    }

    if (filterStartDate != null && filterEndDate != null) {
      filtered = filtered.where((e) {
        return e.date.isAfter(filterStartDate!) &&
            e.date.isBefore(filterEndDate!.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  /// Calculate statistics
  double get totalAmount => expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get todayAmount => todayExpenses.fold(0.0, (sum, e) => sum + e.amount);
  double get weekAmount => weekExpenses.fold(0.0, (sum, e) => sum + e.amount);
  double get monthAmount => monthExpenses.fold(0.0, (sum, e) => sum + e.amount);
  int get totalExpenses => expenses.length;

  /// Get average daily expense for current month
  double get averageDailyExpense {
    if (monthExpenses.isEmpty) return 0.0;
    final daysInMonth = DateTime.now().day;
    return monthAmount / daysInMonth;
  }

  /// Get top spending category
  String? get topCategory {
    if (categoryTotals.isEmpty) return null;
    return categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Copy with new filters
  ExpenseLoaded copyWithFilters({
    String? filterCategory,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool clearFilters = false,
  }) {
    return ExpenseLoaded(
      expenses: expenses,
      todayExpenses: todayExpenses,
      weekExpenses: weekExpenses,
      monthExpenses: monthExpenses,
      categoryTotals: categoryTotals,
      filterCategory: clearFilters
          ? null
          : (filterCategory ?? this.filterCategory),
      filterStartDate: clearFilters
          ? null
          : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearFilters
          ? null
          : (filterEndDate ?? this.filterEndDate),
    );
  }
}

/// State when an expense operation (add/update/delete) is in progress
class ExpenseOperationInProgress extends ExpenseState {
  final List<ExpenseModel> expenses; // Keep existing expenses during operation

  const ExpenseOperationInProgress({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}

/// State when an expense operation succeeds
class ExpenseOperationSuccess extends ExpenseState {
  final String message;

  const ExpenseOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when an error occurs
class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}
