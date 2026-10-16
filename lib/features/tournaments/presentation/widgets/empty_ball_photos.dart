import 'package:flutter/material.dart';

class EmptyBallPhotos extends StatelessWidget {
  const EmptyBallPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.photo_camera_outlined, size: 40),
          SizedBox(height: 8),
          Text('Aucune photo de référence', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
