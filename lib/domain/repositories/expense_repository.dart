import '../entities/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<double> getTotalExpenses();
}