import 'package:finance_tracker/domain/entities/expense.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';
import '../datasources/remote/firestore_service.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirestoreService _firestore;
  
  ExpenseRepositoryImpl(this._firestore);
  
  @override
  Stream<List<Expense>> getExpenses() {
    return _firestore.getExpenses();
  }
  
  @override
  Future<void> addExpense(Expense expense) async {
    await _firestore.addExpense(expense);
  }
  
  @override
  Future<void> deleteExpense(String id) async {
    await _firestore.deleteExpense(id);
  }
  
  @override
  Future<double> getTotalExpenses() async {
    return await _firestore.getTotalExpenses();
  }
}