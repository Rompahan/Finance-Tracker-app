import 'package:finance_tracker/data/datasources/local/app_database.dart';
import 'package:finance_tracker/data/datasources/remote/firestore_service.dart';
import 'package:finance_tracker/domain/entities/expense.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';
import 'package:drift/drift.dart' as drift;

class ExpenseRepositoryImpl implements ExpenseRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestore;

  ExpenseRepositoryImpl(this._localDb, this._firestore);

  @override
  Future<List<Expense>> getExpenses() async {
    final localExpenses = await _localDb.getAllExpenses();
    return localExpenses
        .map((e) => Expense(
              id: e.id,
              amount: e.amount,
              category: e.category,
              description: e.description,
              date: e.date,
              firestoreId: e.firestoreId,
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

    await _localDb.insertExpense(ExpensesCompanion(
      amount: drift.Value(expense.amount),
      category: drift.Value(expense.category),
      description: drift.Value(expense.description),
      date: drift.Value(expense.date),
      firestoreId: drift.Value(firestoreId),
    ));
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
    final total = await _localDb.getTotalExpenses();
    return total;
  }
}
