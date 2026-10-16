import 'dart:io';

import 'package:flutter/material.dart';

import '../data/petanque_ball_photo_repository.dart';

/// Full screen, zoomable reference photo.
class BallPhotoViewerScreen extends StatelessWidget {
  final PetanqueBallPhoto photo;

  const BallPhotoViewerScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo de référence')),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(
            File(photo.path),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                'Photo introuvable',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
