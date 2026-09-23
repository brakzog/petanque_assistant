import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class PlayerBallData {
  final String id;
  final String playerId;
  final String? brand;
  final String? model;
  final int? diameter;
  final int? weight;

  const PlayerBallData({
    required this.id,
    required this.playerId,
    this.brand,
    this.model,
    this.diameter,
    this.weight,
  });
}

class PetanqueBallRepository {
  final AppDatabase database;

  PetanqueBallRepository(this.database);

  Future<PlayerBallData?> getForPlayer(String playerId) async {
    final row = await (database.select(database.petanqueBalls)
          ..where((table) => table.playerId.equals(playerId)))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return PlayerBallData(
      id: row.id,
      playerId: row.playerId,
      brand: row.brand,
      model: row.model,
      diameter: row.diameter,
      weight: row.weight,
    );
  }

  Future<void> save(PlayerBallData ball) async {
    await database.into(database.petanqueBalls).insertOnConflictUpdate(
          PetanqueBallsCompanion(
            id: Value(ball.id),
            playerId: Value(ball.playerId),
            brand: Value(ball.brand),
            model: Value(ball.model),
            diameter: Value(ball.diameter),
            weight: Value(ball.weight),
          ),
        );
  }

  Future<void> deleteForPlayer(String playerId) async {
    await (database.delete(database.petanqueBalls)
          ..where((table) => table.playerId.equals(playerId)))
        .go();
  }
}