import 'package:finance_tracker/domain/entities/expense.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<Expense>> call() async {
    return await repository.getExpenses();
  }
}
