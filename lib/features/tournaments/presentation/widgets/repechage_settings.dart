import 'package:flutter/material.dart';

import '../tournament_form_validators.dart';

/// First-round repechage toggle and the number of losers brought back.
class RepechageSettings extends StatelessWidget {
  const RepechageSettings({
    super.key,
    required this.enabled,
    required this.onEnabledChanged,
    required this.slotsController,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final TextEditingController slotsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Repêchage au premier tour'),
          subtitle: const Text('Classe les perdants selon leur score.'),
          value: enabled,
          onChanged: onEnabledChanged,
        ),
        if (enabled) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: slotsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nombre de perdants repêchés',
              border: OutlineInputBorder(),
            ),
            validator: TournamentFormValidators.repechageSlots,
          ),
          const SizedBox(height: 8),
          const Text(
            'En cas d’égalité au niveau de la dernière place '
            'qualificative, un barrage sera nécessaire.',
          ),
        ],
      ],
    );
  }
}
