import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/petanque_ball_photo_repository.dart';

/// Thumbnail of a reference photo with a delete button.
class BallPhotoTile extends StatelessWidget {
  final PetanqueBallPhoto photo;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const BallPhotoTile({
    super.key,
    required this.photo,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onOpen,
            child: Image.file(
              File(photo.path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
