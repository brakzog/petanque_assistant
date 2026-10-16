import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/ball_form_input.dart';

void main() {
  test('accepts empty fields', () {
    const input = BallFormInput();

    expect(input.error, isNull);

    final ball = input.toBall(id: 'b', playerId: 'p');
    expect(ball.brand, isNull);
    expect(ball.model, isNull);
    expect(ball.diameter, isNull);
    expect(ball.weight, isNull);
  });

  test('trims texts and parses numbers', () {
    const input = BallFormInput(
      brand: ' Obut ',
      model: '  ',
      diameter: ' 74 ',
      weight: '690',
    );

    expect(input.error, isNull);

    final ball = input.toBall(id: 'b', playerId: 'p');
    expect(ball.id, 'b');
    expect(ball.playerId, 'p');
    expect(ball.brand, 'Obut');
    expect(ball.model, isNull);
    expect(ball.diameter, 74);
    expect(ball.weight, 690);
  });

  test('rejects non numeric diameter or weight', () {
    expect(
      const BallFormInput(diameter: '74mm').error,
      'Le diamètre doit être un nombre.',
    );
    expect(
      const BallFormInput(weight: 'lourd').error,
      'Le poids doit être un nombre.',
    );
  });
}
