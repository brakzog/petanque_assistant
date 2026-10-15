import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Single shared database instance for the whole app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
