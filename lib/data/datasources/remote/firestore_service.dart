import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/expense.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'expenses';

  Future<String> addExpense(Expense expense) async {
    final doc = await _firestore.collection(_collection).add({
      'amount': expense.amount,
      'category': expense.category,
      'description': expense.description,
      'date': expense.date.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // Явно указываем тип Stream<List<Expense>>
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense(
          id: null,
          amount: (doc.data()['amount'] ?? 0).toDouble(),
          category: doc.data()['category'] ?? '',
          description: doc.data()['description'] ?? '',
          date: DateTime.parse(doc.data()['date']),
          firestoreId: doc.id,
        );
      }).toList();
    });
  }

  Future<void> deleteExpense(String docId) async {
    await _firestore.collection(_collection).doc(docId).delete();
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
