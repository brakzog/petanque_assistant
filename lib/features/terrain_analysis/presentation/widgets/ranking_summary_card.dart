import 'package:flutter/material.dart';

class RankingSummaryCard extends StatelessWidget {
  const RankingSummaryCard({super.key, required this.rankedCount});

  final int rankedCount;

  @override
  Widget build(BuildContext context) {
    final plural = rankedCount > 1 ? 's' : '';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_list_numbered),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ordre des boules',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$rankedCount boule$plural classée$plural. '
                    '1 est la plus proche du cochonnet.',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Le classement applique une correction de perspective relative. '
                    'Aucune fausse distance en centimètres n’est affichée.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
