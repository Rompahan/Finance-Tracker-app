import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String? firestoreId;

  const Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.firestoreId,
  });

  @override
  List<Object?> get props =>
      [id, amount, category, description, date, firestoreId];
}
