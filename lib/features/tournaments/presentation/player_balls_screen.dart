import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';
import '../data/petanque_ball_photo_repository.dart';
import '../data/petanque_ball_repository.dart';

class PlayerBallsScreen extends StatefulWidget {
  final Player player;

  const PlayerBallsScreen({
    super.key,
    required this.player,
  });

  @override
  State<PlayerBallsScreen> createState() =>
      _PlayerBallsScreenState();
}

class _PlayerBallsScreenState
    extends State<PlayerBallsScreen> {
  late final AppDatabase _database;
  late final PetanqueBallRepository _ballRepository;
  late final PetanqueBallPhotoRepository _photoRepository;

  final ImagePicker _imagePicker = ImagePicker();

  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _diameterController = TextEditingController();
  final _weightController = TextEditingController();

  PlayerBallData? _ball;
  List<PetanqueBallPhoto> _photos = [];

  bool _loading = true;
  bool _saving = false;
  bool _addingPhoto = false;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();

    _ballRepository =
        PetanqueBallRepository(_database);

    _photoRepository =
        PetanqueBallPhotoRepository(_database);

    _load();
  }

  Future<void> _load() async {
    final ball = await _ballRepository.getForPlayer(
      widget.player.id,
    );

    List<PetanqueBallPhoto> photos = [];

    if (ball != null) {
      photos = await _photoRepository.getForBall(
        ball.id,
      );
    }

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
      _photos = photos;
      _loading = false;
    });
  }

  Future<PlayerBallData?> _saveBall({
    bool showMessage = true,
  }) async {
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

      return null;
    }

    if (_weightController.text.trim().isNotEmpty &&
        weight == null) {
      _showMessage(
        'Le poids doit être un nombre.',
      );

      return null;
    }

    final ball = PlayerBallData(
      id: _ball?.id ?? const Uuid().v4(),
      playerId: widget.player.id,
      brand: _nullIfEmpty(
        _brandController.text,
      ),
      model: _nullIfEmpty(
        _modelController.text,
      ),
      diameter: diameter,
      weight: weight,
    );

    await _ballRepository.save(ball);

    if (!mounted) {
      return ball;
    }

    setState(() {
      _ball = ball;
    });

    if (showMessage) {
      _showMessage(
        'Boules enregistrées.',
      );
    }

    return ball;
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    try {
      await _saveBall();
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    await _pickPhoto(
      ImageSource.camera,
    );
  }

  Future<void> _choosePhoto() async {
    await _pickPhoto(
      ImageSource.gallery,
    );
  }

  Future<void> _pickPhoto(
    ImageSource source,
  ) async {
    if (_addingPhoto) {
      return;
    }

    setState(() {
      _addingPhoto = true;
    });

    try {
      // Une photo doit obligatoirement être rattachée
      // à un jeu de boules existant.
      final ball =
          _ball ?? await _saveBall(showMessage: false);

      if (ball == null) {
        return;
      }

      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (image == null) {
        return;
      }

      await _photoRepository.importPhoto(
        petanqueBallId: ball.id,
        sourcePath: image.path,
      );

      final photos =
          await _photoRepository.getForBall(ball.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _photos = photos;
      });
    } catch (error) {
      _showMessage(
        'Impossible d\'ajouter la photo : $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _addingPhoto = false;
        });
      }
    }
  }

  Future<void> _deletePhoto(
    PetanqueBallPhoto photo,
  ) async {
    final confirmed =
        await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Supprimer la photo ?',
                  ),
                  content: const Text(
                    'Cette photo de référence sera '
                    'définitivement supprimée.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Supprimer'),
                    ),
                  ],
                );
              },
            ) ??
            false;

    if (!confirmed) {
      return;
    }

    await _photoRepository.delete(photo);

    if (_ball == null) {
      return;
    }

    final photos = await _photoRepository.getForBall(
      _ball!.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _photos = photos;
    });
  }

  void _showPhoto(
    PetanqueBallPhoto photo,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Photo de référence',
            ),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.file(
                File(photo.path),
                fit: BoxFit.contain,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child: Text(
                      'Photo introuvable',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  'Renseignez les boules utilisées par '
                  '${widget.player.name}.',
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: _brandController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Marque',
                    hintText: 'Ex. OBUT',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _modelController,
                  textCapitalization:
                      TextCapitalization.words,
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
                          child:
                              CircularProgressIndicator(
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

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'Photos de référence',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Ajoutez plusieurs vues des boules. '
                  'Elles serviront plus tard à identifier '
                  'le joueur lors de l\'analyse du terrain.',
                ),

                const SizedBox(height: 16),

                if (_photos.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant,
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Aucune photo de référence',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: _photos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final photo = _photos[index];

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Material(
                            clipBehavior: Clip.antiAlias,
                            borderRadius:
                                BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () =>
                                  _showPhoto(photo),
                              child: Image.file(
                                File(photo.path),
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return const Center(
                                    child: Icon(
                                      Icons
                                          .broken_image_outlined,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          Positioned(
                            top: 4,
                            right: 4,
                            child: Material(
                              color: Colors.black54,
                              shape:
                                  const CircleBorder(),
                              child: InkWell(
                                customBorder:
                                    const CircleBorder(),
                                onTap: () =>
                                    _deletePhoto(photo),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed:
                      _addingPhoto ? null : _takePhoto,
                  icon: const Icon(
                    Icons.photo_camera,
                  ),
                  label: Text(
                    _addingPhoto
                        ? 'Ajout en cours...'
                        : 'Prendre une photo',
                  ),
                ),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed:
                      _addingPhoto ? null : _choosePhoto,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  label: const Text(
                    'Choisir dans la galerie',
                  ),
                ),

                if (_photos.isNotEmpty) ...[
                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      '${_photos.length} photo(s) de référence',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
    );
  }
}