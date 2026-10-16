import 'package:flutter/material.dart';

import '../../data/petanque_ball_photo_repository.dart';
import 'ball_photo_tile.dart';

class BallPhotoGrid extends StatelessWidget {
  final List<PetanqueBallPhoto> photos;
  final ValueChanged<PetanqueBallPhoto> onOpen;
  final ValueChanged<PetanqueBallPhoto> onDelete;

  const BallPhotoGrid({
    super.key,
    required this.photos,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return BallPhotoTile(
          photo: photo,
          onOpen: () => onOpen(photo),
          onDelete: () => onDelete(photo),
        );
      },
    );
  }
}
