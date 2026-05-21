import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get firestoreId => text().nullable()();
}

@DriftDatabase(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Expense>> getAllExpenses() async {
    return await select(expenses).get();
  }

  Future<int> insertExpense(ExpensesCompanion expense) async {
    return await into(expenses).insert(expense);
  }

  Future<void> deleteExpense(int id) async {
    await (delete(expenses)..where((t) => t.id.equals(id))).go();
  }

  Future<double> getTotalExpenses() async {
    final result = await (select(expenses)..columns([expenses.amount]))
        .map((row) => row.read(expenses.amount))
        .get();

    return result.fold(0.0, (sum, amount) => sum + amount);
  }

  Future<void> updateFirestoreId(int id, String firestoreId) async {
    await (update(expenses)..where((t) => t.id.equals(id)))
        .write(ExpensesCompanion(firestoreId: Value(firestoreId)));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finance_tracker.sqlite'));
    return NativeDatabase(file);
  });
}
