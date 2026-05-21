import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

class ExpenseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get firestoreId => text().nullable()();
}

@DriftDatabase(tables: [ExpenseTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ExpenseTableData>> getAllExpenses() async {
    return await select(expenseTable).get();
  }

  Future<int> insertExpense(
    double amount,
    String category,
    String description,
    DateTime date, {
    String? firestoreId,
  }) async {
    return await into(expenseTable).insert(
      ExpenseTableCompanion(
        amount: Value(amount),
        category: Value(category),
        description: Value(description),
        date: Value(date),
        firestoreId:
            firestoreId != null ? Value(firestoreId) : const Value.absent(),
      ),
    );
  }

  Future<void> deleteExpense(int id) async {
    await (delete(expenseTable)..where((t) => t.id.equals(id))).go();
  }

  Future<double> getTotalExpenses() async {
    final all = await select(expenseTable).get();
    double total = 0;
    for (var item in all) {
      total += item.amount;
    }
    return total;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finance_tracker.sqlite'));
    return NativeDatabase(file);
  });
}
