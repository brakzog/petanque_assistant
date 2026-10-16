import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/media/media_providers.dart';
import '../../../domain/player.dart';
import '../data/ball_photo_service.dart';
import '../data/petanque_ball_photo_repository.dart';
import '../data/petanque_ball_repository.dart';
import '../data/tournament_providers.dart';
import '../domain/ball_form_input.dart';
import 'player_balls_state.dart';

final playerBallsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PlayerBallsController, PlayerBalls, Player>(
      PlayerBallsController.new,
    );

enum PhotoSource { camera, gallery }

/// Ball set and reference photos of a player. Each change returns the
/// message to show, or null when there is nothing to say.
class PlayerBallsController extends AsyncNotifier<PlayerBalls> {
  PlayerBallsController(this._player);

  final Player _player;

  PetanqueBallRepository get _ballRepository =>
      ref.read(petanqueBallRepositoryProvider);

  BallPhotoService get _photoService => ref.read(ballPhotoServiceProvider);

  @override
  Future<PlayerBalls> build() async {
    final ball = await _ballRepository.getForPlayer(_player.id);
    final photos = ball == null
        ? const <PetanqueBallPhoto>[]
        : await _photoService.getForBall(ball.id);
    return PlayerBalls(ball: ball, photos: photos);
  }

  Future<String?> save(BallFormInput input) async {
    final error = input.error;
    if (error != null) return error;

    final ball = await _saveBall(input);
    return ball == null ? null : 'Boules enregistrées.';
  }

  /// A photo needs a saved ball set, so the form is saved first if needed.
  Future<String?> addPhoto(PhotoSource source, BallFormInput input) async {
    final photoService = _photoService;
    final existing = state.value?.ball;
    if (existing == null && input.error != null) return input.error;

    try {
      final ball = existing ?? await _saveBall(input);
      if (ball == null) return null;

      final image = await _pick(source);
      if (image == null) return null;

      await photoService.importPhoto(
        petanqueBallId: ball.id,
        sourcePath: image.path,
      );
      await _reloadPhotos(photoService, ball);
      return null;
    } catch (error) {
      return 'Impossible d\'ajouter la photo : $error';
    }
  }

  Future<void> deletePhoto(PetanqueBallPhoto photo) async {
    final photoService = _photoService;
    await photoService.delete(photo);
    final ball = state.value?.ball;
    if (ball != null) await _reloadPhotos(photoService, ball);
  }

  /// Returns null while the screen data is not loaded yet.
  Future<PlayerBallData?> _saveBall(BallFormInput input) async {
    final current = state.value;
    if (current == null) return null;

    final ball = input.toBall(
      id: current.ball?.id ?? ref.read(ballIdGeneratorProvider)(),
      playerId: _player.id,
    );
    await _ballRepository.save(ball);
    if (ref.mounted) state = AsyncData(current.copyWith(ball: ball));
    return ball;
  }

  Future<XFile?> _pick(PhotoSource source) {
    final picker = ref.read(photoPickerProvider);
    return switch (source) {
      PhotoSource.camera => picker.takePhoto(),
      PhotoSource.gallery => picker.pickFromGallery(),
    };
  }

  Future<void> _reloadPhotos(
    BallPhotoService photoService,
    PlayerBallData ball,
  ) async {
    final photos = await photoService.getForBall(ball.id);
    if (!ref.mounted) return;
    final current = state.value;
    if (current != null) state = AsyncData(current.copyWith(photos: photos));
  }
}
