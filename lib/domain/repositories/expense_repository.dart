import 'package:finance_tracker/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(int id, {String? firestoreId});
  Future<double> getTotalExpenses();
  Stream<List<Expense>> getExpensesStream();
}
