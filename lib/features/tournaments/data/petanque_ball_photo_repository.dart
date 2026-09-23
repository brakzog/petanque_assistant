import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  Future<List<PetanqueBallPhoto>> getForBall(
    String petanqueBallId,
  ) async {
    final rows = await (database.select(database.petanqueBallPhotos)
          ..where(
            (table) =>
                table.petanqueBallId.equals(petanqueBallId),
          )
          ..orderBy([
            (table) => OrderingTerm.asc(table.createdAt),
          ]))
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

  Future<PetanqueBallPhoto> importPhoto({
    required String petanqueBallId,
    required String sourcePath,
  }) async {
    final documentsDirectory =
        await getApplicationDocumentsDirectory();

    final photoDirectory = Directory(
      p.join(
        documentsDirectory.path,
        'petanque_ball_photos',
        petanqueBallId,
      ),
    );

    if (!await photoDirectory.exists()) {
      await photoDirectory.create(
        recursive: true,
      );
    }

    final id = const Uuid().v4();

    var extension = p.extension(sourcePath).toLowerCase();

    if (extension.isEmpty) {
      extension = '.jpg';
    }

    final destinationPath = p.join(
      photoDirectory.path,
      '$id$extension',
    );

    final sourceFile = File(sourcePath);

    await sourceFile.copy(destinationPath);

    final photo = PetanqueBallPhoto(
      id: id,
      petanqueBallId: petanqueBallId,
      path: destinationPath,
      createdAt: DateTime.now(),
    );

    await database.into(database.petanqueBallPhotos).insert(
          PetanqueBallPhotosCompanion.insert(
            id: photo.id,
            petanqueBallId: photo.petanqueBallId,
            path: photo.path,
            createdAt: photo.createdAt,
          ),
        );

    return photo;
  }

  Future<void> delete(PetanqueBallPhoto photo) async {
    await (database.delete(database.petanqueBallPhotos)
          ..where((table) => table.id.equals(photo.id)))
        .go();

    final file = File(photo.path);

    if (await file.exists()) {
      await file.delete();
    }
  }
}