import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'transaction_runner.dart';

/// Single shared database instance for the whole app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final transactionRunnerProvider = Provider<TransactionRunner>(
  (ref) => DriftTransactionRunner(ref.watch(appDatabaseProvider)),
);
