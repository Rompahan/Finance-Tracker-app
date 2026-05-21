import 'package:finance_tracker/domain/entities/expense.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) async {
    return await repository.addExpense(expense);
  }
}
