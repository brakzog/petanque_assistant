import 'package:flutter/material.dart';

import '../ball_form_controllers.dart';

/// Brand, model, diameter and weight fields of a ball set.
class BallFormFields extends StatelessWidget {
  final BallFormControllers controllers;

  const BallFormFields({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _textField(controllers.brand, 'Marque', 'Ex. OBUT'),
        const SizedBox(height: 16),
        _textField(controllers.model, 'Modèle', 'Ex. Match+'),
        const SizedBox(height: 16),
        _numberField(controllers.diameter, 'Diamètre', 'mm', 'Ex. 74'),
        const SizedBox(height: 16),
        _numberField(controllers.weight, 'Poids', 'g', 'Ex. 700'),
      ],
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
    String suffix,
    String hint,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
