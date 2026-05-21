import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/remote/firestore_service.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/entities/expense.dart';

final appDatabaseProvider = Provider((ref) => AppDatabase());
final firestoreServiceProvider = Provider((ref) => FirestoreService());

final expenseRepositoryProvider = Provider((ref) {
  final localDb = ref.watch(appDatabaseProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  return ExpenseRepositoryImpl(localDb, firestore);
});

final getExpensesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return GetExpensesUseCase(repo);
});

final addExpenseUseCaseProvider = Provider((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return AddExpenseUseCase(repo);
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getExpensesStream();
});

final totalExpensesProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(expenseRepositoryProvider);
  return await repo.getTotalExpenses();
});
