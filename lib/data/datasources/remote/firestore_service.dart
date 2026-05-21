import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/expense.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'expenses';
  
  Future<void> addExpense(Expense expense) async {
    await _firestore.collection(_collection).add({
      'amount': expense.amount,
      'category': expense.category,
      'description': expense.description,
      'date': expense.date.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Expense(
          id: doc.id,
          amount: (data['amount'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          date: DateTime.parse(data['date']),
        );
      }).toList();
    });
  }
  
  Future<void> deleteExpense(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
  
  Future<double> getTotalExpenses() async {
    final query = await _firestore.collection(_collection).get();
    double total = 0;
    for (var doc in query.docs) {
      total += (doc.data()['amount'] ?? 0);
    }
    return total;
  }
}