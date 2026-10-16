import 'ball_photo_file_store.dart';
import 'petanque_ball_photo_repository.dart';

/// Reference photos of a ball set: file copy plus database record.
class BallPhotoService {
  const BallPhotoService({
    required this.repository,
    required this.fileStore,
    required this.newId,
    required this.now,
  });

  final PetanqueBallPhotoRepository repository;
  final BallPhotoFileStore fileStore;
  final String Function() newId;
  final DateTime Function() now;

  Future<List<PetanqueBallPhoto>> getForBall(String petanqueBallId) {
    return repository.getForBall(petanqueBallId);
  }

  Future<PetanqueBallPhoto> importPhoto({
    required String petanqueBallId,
    required String sourcePath,
  }) async {
    final id = newId();
    final path = await fileStore.copyIn(
      petanqueBallId: petanqueBallId,
      photoId: id,
      sourcePath: sourcePath,
    );

    final photo = PetanqueBallPhoto(
      id: id,
      petanqueBallId: petanqueBallId,
      path: path,
      createdAt: now(),
    );
    await repository.insert(photo);
    return photo;
  }

  Future<void> delete(PetanqueBallPhoto photo) async {
    await repository.delete(photo.id);
    await fileStore.delete(photo.path);
  }
}
