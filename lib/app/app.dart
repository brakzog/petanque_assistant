import 'package:flutter/material.dart';

import '../features/tournaments/presentation/tournament_list_screen.dart';

class PetanqueApp extends StatelessWidget {
  const PetanqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tournoi de Pétanque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const TournamentListScreen(),
    );
  }
}