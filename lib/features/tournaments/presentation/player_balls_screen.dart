import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/player.dart';
import '../data/petanque_ball_photo_repository.dart';
import 'ball_form_controllers.dart';
import 'ball_photo_viewer_screen.dart';
import 'player_balls_controller.dart';
import 'player_balls_state.dart';
import 'widgets/ball_form_fields.dart';
import 'widgets/ball_photo_grid.dart';
import 'widgets/confirm_delete_photo_dialog.dart';
import 'widgets/empty_ball_photos.dart';

class PlayerBallsScreen extends ConsumerStatefulWidget {
  final Player player;

  const PlayerBallsScreen({super.key, required this.player});

  @override
  ConsumerState<PlayerBallsScreen> createState() => _PlayerBallsScreenState();
}

class _PlayerBallsScreenState extends ConsumerState<PlayerBallsScreen> {
  /// Created once the saved ball set is loaded.
  BallFormControllers? _form;

  bool _saving = false;
  bool _addingPhoto = false;

  PlayerBallsController get _controller =>
      ref.read(playerBallsControllerProvider(widget.player).notifier);

  Future<void> _save(BallFormControllers form) async {
    setState(() => _saving = true);
    try {
      _showMessage(await _controller.save(form.input));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addPhoto(BallFormControllers form, PhotoSource source) async {
    if (_addingPhoto) return;

    setState(() => _addingPhoto = true);
    try {
      _showMessage(await _controller.addPhoto(source, form.input));
    } finally {
      if (mounted) setState(() => _addingPhoto = false);
    }
  }

  Future<void> _deletePhoto(PetanqueBallPhoto photo) async {
    if (!await confirmDeletePhoto(context)) return;
    await _controller.deletePhoto(photo);
  }

  void _openPhoto(PetanqueBallPhoto photo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BallPhotoViewerScreen(photo: photo)),
    );
  }

  void _showMessage(String? message) {
    if (message == null || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _form?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balls = ref.watch(playerBallsControllerProvider(widget.player));

    return Scaffold(
      appBar: AppBar(title: Text('Boules de ${widget.player.name}')),
      body: balls.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(error.toString()),
          ),
        ),
        data: _content,
      ),
    );
  }

  Widget _content(PlayerBalls balls) {
    final form = _form ??= BallFormControllers(balls.ball);
    final textTheme = Theme.of(context).textTheme;
    final photos = balls.photos;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Jeu de boules', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Renseignez les boules utilisées par ${widget.player.name}.'),
        const SizedBox(height: 24),
        BallFormFields(controllers: form),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _saving ? null : () => _save(form),
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_saving ? 'Enregistrement...' : 'Enregistrer'),
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        Text('Photos de référence', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Ajoutez plusieurs vues des boules. '
          'Elles serviront plus tard à identifier '
          'le joueur lors de l\'analyse du terrain.',
        ),
        const SizedBox(height: 16),
        if (photos.isEmpty)
          const EmptyBallPhotos()
        else
          BallPhotoGrid(
            photos: photos,
            onOpen: _openPhoto,
            onDelete: _deletePhoto,
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _addingPhoto
              ? null
              : () => _addPhoto(form, PhotoSource.camera),
          icon: const Icon(Icons.photo_camera),
          label: Text(_addingPhoto ? 'Ajout en cours...' : 'Prendre une photo'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addingPhoto
              ? null
              : () => _addPhoto(form, PhotoSource.gallery),
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Choisir dans la galerie'),
        ),
        if (photos.isNotEmpty) ...[
          const SizedBox(height: 12),
          Center(
            child: Text(
              '${photos.length} photo(s) de référence',
              style: textTheme.bodySmall,
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
