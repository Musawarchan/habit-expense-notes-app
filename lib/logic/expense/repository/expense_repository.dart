import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

/// Repository for managing expense data
/// Handles all Firebase Firestore operations for expenses
class ExpenseRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ExpenseRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  /// Reference to expenses collection
  CollectionReference get _expensesCollection =>
      _firestore.collection('expenses');

  /// Stream of expenses for the current user
  /// Returns real-time updates whenever expenses change
  Stream<List<ExpenseModel>> getExpensesStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _expensesCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    ExpenseModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  /// Get all expenses for the current user (one-time fetch)
  Future<List<ExpenseModel>> getExpenses() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _expensesCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get a single expense by ID
  Future<ExpenseModel?> getExpenseById(String expenseId) async {
    final doc = await _expensesCollection.doc(expenseId).get();
    if (!doc.exists) return null;
    return ExpenseModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Add a new expense
  Future<void> addExpense(ExpenseModel expense) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    // Ensure the expense has the correct userId
    final expenseWithUserId = expense.copyWith(userId: _userId!);
    await _expensesCollection
        .doc(expenseWithUserId.id)
        .set(expenseWithUserId.toJson());
  }

  /// Update an existing expense
  Future<void> updateExpense(ExpenseModel expense) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _expensesCollection.doc(expense.id).update(expense.toJson());
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _expensesCollection.doc(expenseId).delete();
  }

  /// Get expenses by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final expenses = await getExpenses();
    return expenses.where((expense) => expense.category == category).toList();
  }

  /// Get expenses by date range
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _expensesCollection
        .where('userId', isEqualTo: _userId)
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get today's expenses
  Future<List<ExpenseModel>> getTodayExpenses() async {
    final expenses = await getExpenses();
    return expenses.where((expense) => expense.isToday).toList();
  }

  /// Get this week's expenses
  Future<List<ExpenseModel>> getWeekExpenses() async {
    final expenses = await getExpenses();
    return expenses.where((expense) => expense.isThisWeek).toList();
  }

  /// Get this month's expenses
  Future<List<ExpenseModel>> getMonthExpenses() async {
    final expenses = await getExpenses();
    return expenses.where((expense) => expense.isThisMonth).toList();
  }

  /// Calculate total expenses by category
  Future<Map<String, double>> getCategoryTotals() async {
    final expenses = await getExpenses();
    final Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  /// Calculate total expenses for a specific period
  Future<double> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<ExpenseModel> expenses;

    if (startDate != null && endDate != null) {
      expenses = await getExpensesByDateRange(startDate, endDate);
    } else {
      expenses = await getExpenses();
    }

    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Get expenses by payment method
  Future<List<ExpenseModel>> getExpensesByPaymentMethod(
    String paymentMethod,
  ) async {
    final expenses = await getExpenses();
    return expenses
        .where((expense) => expense.paymentMethod == paymentMethod)
        .toList();
  }

  /// Get expenses by tags
  Future<List<ExpenseModel>> getExpensesByTag(String tag) async {
    final expenses = await getExpenses();
    return expenses.where((expense) => expense.tags.contains(tag)).toList();
  }
}
