import 'package:flutter/material.dart';

import '../../../../domain/tournament.dart';
import '../petanque_format_label.dart';

class FormatSelector extends StatelessWidget {
  const FormatSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PetanqueFormat value;
  final ValueChanged<PetanqueFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<PetanqueFormat>(
      groupValue: value,
      onChanged: (format) {
        if (format != null) onChanged(format);
      },
      child: Column(
        children: [
          for (final format in PetanqueFormat.values)
            RadioListTile<PetanqueFormat>(
              title: Text(format.label),
              value: format,
            ),
        ],
      ),
    );
  }
}
