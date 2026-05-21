import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/firestore_service.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/get_expenses.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return ExpenseRepositoryImpl(firestore);
});

final addExpenseUseCaseProvider = Provider((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return AddExpenseUseCase(repo);
});

final getExpensesUseCaseProvider = Provider((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return GetExpensesUseCase(repo);
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final useCase = ref.watch(getExpensesUseCaseProvider);
  return useCase();
});

final totalExpensesProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(expenseRepositoryProvider);
  return await repo.getTotalExpenses();
});