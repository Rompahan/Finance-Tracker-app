import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;
  
  GetExpensesUseCase(this.repository);
  
  Stream<List<Expense>> call() {
    return repository.getExpenses();
  }
}