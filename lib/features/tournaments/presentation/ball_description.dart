import '../data/petanque_ball_repository.dart';

/// One-line summary of a player's ball set.
String describeBalls(PlayerBallData? ball) {
  if (ball == null) return 'Boules : non renseignées';

  final brand = ball.brand;
  final model = ball.model;
  final parts = [
    if (brand != null && brand.isNotEmpty) brand,
    if (model != null && model.isNotEmpty) model,
    if (ball.diameter != null) '${ball.diameter} mm',
    if (ball.weight != null) '${ball.weight} g',
  ];

  return parts.isEmpty ? 'Boules : renseignées' : parts.join(' • ');
}
