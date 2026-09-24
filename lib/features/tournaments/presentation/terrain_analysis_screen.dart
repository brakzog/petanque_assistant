import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/petanque_detector.dart';

class TerrainAnalysisScreen extends StatefulWidget {
  const TerrainAnalysisScreen({
    super.key,
  });

  @override
  State<TerrainAnalysisScreen> createState() =>
      _TerrainAnalysisScreenState();
}

class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  bool _pickingImage = false;

  bool _loadingDetector = true;
  String? _detectorInfo;
  String? _detectorError;

  @override
  void initState() {
    super.initState();
    _loadDetector();
  }

  Future<void> _loadDetector() async {
    try {
      await PetanqueDetector.instance.load();

      if (!mounted) {
        return;
      }

      setState(() {
        _loadingDetector = false;
        _detectorInfo = PetanqueDetector.instance.modelInfo;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingDetector = false;
        _detectorError = e.toString();
      });
    }
  }

  Future<void> _takePhoto() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _choosePhoto() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_pickingImage) {
      return;
    }

    setState(() {
      _pickingImage = true;
    });

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (!mounted) {
        return;
      }

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _pickingImage = false;
        });
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse du terrain'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetectorStatus(),

          const SizedBox(height: 24),

          Text(
            'Photo de la mène',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          const Text(
            'Prenez une photo du terrain ou sélectionnez '
            'une photo existante.',
          ),

          const SizedBox(height: 24),

          if (_selectedImage == null) ...[
            FilledButton.icon(
              onPressed: _pickingImage ? null : _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickingImage ? null : _choosePhoto,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choisir dans la galerie'),
            ),
          ] else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_selectedImage!.path),
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickingImage ? null : _choosePhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Changer'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _pickingImage ? null : _removePhoto,
                  tooltip: 'Supprimer la photo',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            Text(
              'Résultat de l\'analyse',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.science_outlined),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Le modèle est intégré. '
                        'L\'inférence sur la photo sera ajoutée '
                        'à l\'étape suivante.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          if (_pickingImage) ...[
            const SizedBox(height: 24),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetectorStatus() {
    if (_loadingDetector) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chargement du modèle de détection...',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_detectorError != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.error_outline),
                  SizedBox(width: 8),
                  Text(
                    'Erreur de chargement du modèle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SelectableText(_detectorError!),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle_outline),
                SizedBox(width: 8),
                Text(
                  'Modèle chargé',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              _detectorInfo ?? 'Informations indisponibles',
            ),
          ],
        ),
      ),
    );
  }
}