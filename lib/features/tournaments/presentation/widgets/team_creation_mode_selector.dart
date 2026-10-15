import 'package:flutter/material.dart';

import '../../../../domain/tournament.dart';

class TeamCreationModeSelector extends StatelessWidget {
  const TeamCreationModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TeamCreationMode value;
  final ValueChanged<TeamCreationMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<TeamCreationMode>(
      groupValue: value,
      onChanged: (mode) {
        if (mode != null) onChanged(mode);
      },
      child: const Column(
        children: [
          RadioListTile<TeamCreationMode>(
            title: Text('Tirage aléatoire'),
            value: TeamCreationMode.random,
          ),
          RadioListTile<TeamCreationMode>(
            title: Text('Équipes prédéfinies'),
            value: TeamCreationMode.predefined,
          ),
        ],
      ),
    );
  }
}
