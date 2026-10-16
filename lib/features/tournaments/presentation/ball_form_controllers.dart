import 'package:flutter/widgets.dart';

import '../data/petanque_ball_repository.dart';
import '../domain/ball_form_input.dart';

/// Text controllers of the ball set form, filled from the saved set.
class BallFormControllers {
  BallFormControllers(PlayerBallData? ball)
    : brand = TextEditingController(text: ball?.brand ?? ''),
      model = TextEditingController(text: ball?.model ?? ''),
      diameter = TextEditingController(text: ball?.diameter?.toString() ?? ''),
      weight = TextEditingController(text: ball?.weight?.toString() ?? '');

  final TextEditingController brand;
  final TextEditingController model;
  final TextEditingController diameter;
  final TextEditingController weight;

  BallFormInput get input => BallFormInput(
    brand: brand.text,
    model: model.text,
    diameter: diameter.text,
    weight: weight.text,
  );

  void dispose() {
    brand.dispose();
    model.dispose();
    diameter.dispose();
    weight.dispose();
  }
}
