import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';
import '../data/petanque_ball_repository.dart';

class PlayerBallsScreen extends StatefulWidget {
  final Player player;

  const PlayerBallsScreen({
    super.key,
    required this.player,
  });

  @override
  State<PlayerBallsScreen> createState() => _PlayerBallsScreenState();
}

class _PlayerBallsScreenState extends State<PlayerBallsScreen> {
  late final AppDatabase _database;
  late final PetanqueBallRepository _repository;

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _diameterController = TextEditingController();
  final _weightController = TextEditingController();

  PlayerBallData? _ball;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _repository = PetanqueBallRepository(_database);

    _load();
  }

  Future<void> _load() async {
    final ball = await _repository.getForPlayer(
      widget.player.id,
    );

    if (!mounted) {
      return;
    }

    _brandController.text = ball?.brand ?? '';
    _modelController.text = ball?.model ?? '';
    _diameterController.text =
        ball?.diameter?.toString() ?? '';
    _weightController.text =
        ball?.weight?.toString() ?? '';

    setState(() {
      _ball = ball;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final diameter = int.tryParse(
      _diameterController.text.trim(),
    );

    final weight = int.tryParse(
      _weightController.text.trim(),
    );

    if (_diameterController.text.trim().isNotEmpty &&
        diameter == null) {
      _showMessage(
        'Le diamètre doit être un nombre.',
      );
      return;
    }

    if (_weightController.text.trim().isNotEmpty &&
        weight == null) {
      _showMessage(
        'Le poids doit être un nombre.',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final ball = PlayerBallData(
      id: _ball?.id ?? const Uuid().v4(),
      playerId: widget.player.id,
      brand: _nullIfEmpty(_brandController.text),
      model: _nullIfEmpty(_modelController.text),
      diameter: diameter,
      weight: weight,
    );

    await _repository.save(ball);

    if (!mounted) {
      return;
    }

    setState(() {
      _ball = ball;
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Boules enregistrées.',
        ),
      ),
    );
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _diameterController.dispose();
    _weightController.dispose();

    _database.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boules de ${widget.player.name}',
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Jeu de boules',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  'Renseignez les boules utilisées par '
                  '${widget.player.name}.',
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: _brandController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Marque',
                    hintText: 'Ex. OBUT',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _modelController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Modèle',
                    hintText: 'Ex. Match+',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _diameterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Diamètre',
                    suffixText: 'mm',
                    hintText: 'Ex. 74',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Poids',
                    suffixText: 'g',
                    hintText: 'Ex. 700',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _saving
                        ? 'Enregistrement...'
                        : 'Enregistrer',
                  ),
                ),

                if (_ball != null) ...[
                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Jeu de boules enregistré',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}