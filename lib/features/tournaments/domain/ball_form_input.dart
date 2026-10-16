import '../data/petanque_ball_repository.dart';

/// Raw texts typed in the ball set form.
class BallFormInput {
  const BallFormInput({
    this.brand = '',
    this.model = '',
    this.diameter = '',
    this.weight = '',
  });

  final String brand;
  final String model;
  final String diameter;
  final String weight;

  /// The message to show, or null when the input can be saved.
  String? get error {
    if (!_isEmptyOrNumber(diameter)) return 'Le diamètre doit être un nombre.';
    if (!_isEmptyOrNumber(weight)) return 'Le poids doit être un nombre.';
    return null;
  }

  /// Only valid when [error] is null.
  PlayerBallData toBall({required String id, required String playerId}) {
    return PlayerBallData(
      id: id,
      playerId: playerId,
      brand: _nullIfEmpty(brand),
      model: _nullIfEmpty(model),
      diameter: int.tryParse(diameter.trim()),
      weight: int.tryParse(weight.trim()),
    );
  }

  static bool _isEmptyOrNumber(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || int.tryParse(trimmed) != null;
  }

  static String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
