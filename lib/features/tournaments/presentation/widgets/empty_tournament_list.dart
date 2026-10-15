import 'package:flutter/material.dart';

class EmptyTournamentList extends StatelessWidget {
  const EmptyTournamentList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports, size: 72),
          SizedBox(height: 24),
          Text(
            'Aucun tournoi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Créez votre premier tournoi de pétanque.'),
        ],
      ),
    );
  }
}
