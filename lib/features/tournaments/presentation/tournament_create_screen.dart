import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/tournament.dart';
import '../data/tournament_providers.dart';
import 'tournament_form_validators.dart';
import 'widgets/format_selector.dart';
import 'widgets/repechage_settings.dart';
import 'widgets/section_title.dart';
import 'widgets/team_creation_mode_selector.dart';

/// Pops with the new [Tournament], not yet saved.
class TournamentCreateScreen extends ConsumerStatefulWidget {
  const TournamentCreateScreen({super.key});

  @override
  ConsumerState<TournamentCreateScreen> createState() =>
      _TournamentCreateScreenState();
}

class _TournamentCreateScreenState
    extends ConsumerState<TournamentCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _targetScoreController = TextEditingController(text: '13');
  final _repechageSlotsController = TextEditingController(text: '3');

  DateTime _date = DateTime.now();
  PetanqueFormat _format = PetanqueFormat.doubles;
  TeamCreationMode _teamCreationMode = TeamCreationMode.random;
  bool _allowRepechage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _targetScoreController.dispose();
    _repechageSlotsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) setState(() => _date = selectedDate);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final tournament = ref
        .read(tournamentFactoryProvider)
        .create(
          name: _nameController.text,
          location: _locationController.text,
          date: _date,
          format: _format,
          teamCreationMode: _teamCreationMode,
          targetScore: int.parse(_targetScoreController.text),
          repechageSlots: _allowRepechage
              ? int.parse(_repechageSlotsController.text)
              : null,
        );

    Navigator.of(context).pop(tournament);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau tournoi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du tournoi',
                border: OutlineInputBorder(),
              ),
              validator: TournamentFormValidators.name,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(formatDate(_date)),
              trailing: const Icon(Icons.calendar_month),
              onTap: _selectDate,
            ),
            const Divider(),
            const SectionTitle('Format'),
            FormatSelector(
              value: _format,
              onChanged: (format) => setState(() => _format = format),
            ),
            const Divider(),
            const SectionTitle('Composition des équipes'),
            TeamCreationModeSelector(
              value: _teamCreationMode,
              onChanged: (mode) => setState(() => _teamCreationMode = mode),
            ),
            const Divider(),
            TextFormField(
              controller: _targetScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Score pour gagner',
                suffixText: 'points',
                border: OutlineInputBorder(),
              ),
              validator: TournamentFormValidators.targetScore,
            ),
            const SizedBox(height: 16),
            RepechageSettings(
              enabled: _allowRepechage,
              onEnabledChanged: (enabled) =>
                  setState(() => _allowRepechage = enabled),
              slotsController: _repechageSlotsController,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Créer le tournoi'),
            ),
          ],
        ),
      ),
    );
  }
}
