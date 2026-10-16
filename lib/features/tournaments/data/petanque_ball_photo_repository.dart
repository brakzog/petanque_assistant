import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class PetanqueBallPhoto {
  final String id;
  final String petanqueBallId;
  final String path;
  final DateTime createdAt;

  const PetanqueBallPhoto({
    required this.id,
    required this.petanqueBallId,
    required this.path,
    required this.createdAt,
  });
}

class PetanqueBallPhotoRepository {
  final AppDatabase database;

  PetanqueBallPhotoRepository(this.database);

  Future<List<PetanqueBallPhoto>> getForBall(String petanqueBallId) async {
    final rows =
        await (database.select(database.petanqueBallPhotos)
              ..where((table) => table.petanqueBallId.equals(petanqueBallId))
              ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
            .get();

    return rows
        .map(
          (row) => PetanqueBallPhoto(
            id: row.id,
            petanqueBallId: row.petanqueBallId,
            path: row.path,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<void> insert(PetanqueBallPhoto photo) async {
    await database
        .into(database.petanqueBallPhotos)
        .insert(
          PetanqueBallPhotosCompanion.insert(
            id: photo.id,
            petanqueBallId: photo.petanqueBallId,
            path: photo.path,
            createdAt: photo.createdAt,
          ),
        );
  }

  Future<void> delete(String id) async {
    await (database.delete(
      database.petanqueBallPhotos,
    )..where((table) => table.id.equals(id))).go();
  }
}
