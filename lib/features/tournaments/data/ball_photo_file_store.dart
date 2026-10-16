import 'dart:io';

import 'package:path/path.dart' as p;

/// Keeps copies of the reference photos in the app documents directory.
class BallPhotoFileStore {
  const BallPhotoFileStore({required this.documentsDirectory});

  static const _folder = 'petanque_ball_photos';
  static const _defaultExtension = '.jpg';

  final Future<Directory> Function() documentsDirectory;

  /// Copies [sourcePath] and returns the path of the copy.
  Future<String> copyIn({
    required String petanqueBallId,
    required String photoId,
    required String sourcePath,
  }) async {
    final documents = await documentsDirectory();
    final directory = Directory(
      p.join(documents.path, _folder, petanqueBallId),
    );
    await directory.create(recursive: true);

    var extension = p.extension(sourcePath).toLowerCase();
    if (extension.isEmpty) extension = _defaultExtension;

    final destination = p.join(directory.path, '$photoId$extension');
    await File(sourcePath).copy(destination);
    return destination;
  }

  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
