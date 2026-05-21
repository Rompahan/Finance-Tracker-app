import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  
  const Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });
  
  @override
  List<Object?> get props => [id, amount, category, description, date];
}