import '../data/petanque_ball_photo_repository.dart';
import '../data/petanque_ball_repository.dart';

/// A player's ball set and its reference photos.
class PlayerBalls {
  const PlayerBalls({required this.ball, required this.photos});

  /// Null until the ball set is saved once.
  final PlayerBallData? ball;
  final List<PetanqueBallPhoto> photos;

  PlayerBalls copyWith({
    PlayerBallData? ball,
    List<PetanqueBallPhoto>? photos,
  }) {
    return PlayerBalls(ball: ball ?? this.ball, photos: photos ?? this.photos);
  }
}
