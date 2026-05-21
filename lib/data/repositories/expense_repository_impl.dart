import 'package:finance_tracker/domain/entities/expense.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/remote/firestore_service.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestore;

  ExpenseRepositoryImpl(this._localDb, this._firestore);

  @override
  Future<List<Expense>> getExpenses() async {
    final localData = await _localDb.getAllExpenses();
    return localData
        .map((row) => Expense(
              id: row.id,
              amount: row.amount,
              category: row.category,
              description: row.description,
              date: row.date,
              firestoreId: row.firestoreId,
            ))
        .toList();
  }

  @override
  Stream<List<Expense>> getExpensesStream() {
    return _firestore.getExpenses();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    final firestoreId = await _firestore.addExpense(expense);
    await _localDb.insertExpense(
      expense.amount,
      expense.category,
      expense.description,
      expense.date,
      firestoreId: firestoreId,
    );
  }

  @override
  Future<void> deleteExpense(int id, {String? firestoreId}) async {
    if (firestoreId != null) {
      await _firestore.deleteExpense(firestoreId);
    }
    await _localDb.deleteExpense(id);
  }

  @override
  Future<double> getTotalExpenses() async {
    return await _localDb.getTotalExpenses();
  }
}
