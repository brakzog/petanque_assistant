import 'app_database.dart';

/// Runs a group of writes atomically.
abstract interface class TransactionRunner {
  Future<T> run<T>(Future<T> Function() action);
}

class DriftTransactionRunner implements TransactionRunner {
  const DriftTransactionRunner(this._database);

  final AppDatabase _database;

  @override
  Future<T> run<T>(Future<T> Function() action) {
    return _database.transaction(action);
  }
}
