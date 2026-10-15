import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/features/tournaments/data/petanque_ball_repository.dart';
import 'package:tournoi_de_petanque/features/tournaments/presentation/ball_description.dart';

void main() {
  test('says when balls are not filled in', () {
    expect(describeBalls(null), 'Boules : non renseignées');
  });

  test('joins the known fields', () {
    const ball = PlayerBallData(
      id: 'b',
      playerId: 'p',
      brand: 'Obut',
      model: '',
      diameter: 74,
      weight: 690,
    );

    expect(describeBalls(ball), 'Obut • 74 mm • 690 g');
  });

  test('falls back when the set has no detail', () {
    const ball = PlayerBallData(id: 'b', playerId: 'p');

    expect(describeBalls(ball), 'Boules : renseignées');
  });
}
