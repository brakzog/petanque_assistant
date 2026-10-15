import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../terrain_analysis_providers.dart';
import 'petanque_camera_screen.dart';
import 'terrain_analysis_controller.dart';
import 'terrain_analysis_state.dart';
import 'widgets/analysis_result_card.dart';
import 'widgets/capture_mode_card.dart';
import 'widgets/detection_image.dart';
import 'widgets/ignore_detection_sheet.dart';
import 'widgets/jack_validation_card.dart';
import 'widgets/ranking_summary_card.dart';
import 'widgets/restore_ignored_button.dart';
import 'widgets/warning_card.dart';

class TerrainAnalysisScreen extends ConsumerWidget {
  const TerrainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(terrainAnalysisControllerProvider);
    final controller = ref.read(terrainAnalysisControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Quelle boule est devant ?')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Photo de la mène',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Cadrez le cochonnet et les boules susceptibles de prendre le point.',
          ),
          const SizedBox(height: 24),
          if (state.image == null)
            ..._photoSourceButtons(context, state, controller)
          else
            ..._analysis(context, ref, state, controller),
          if (state.pickingImage) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  List<Widget> _photoSourceButtons(
    BuildContext context,
    TerrainAnalysisState state,
    TerrainAnalysisController controller,
  ) {
    return [
      FilledButton.icon(
        onPressed: state.isBusy ? null : () => _takePhoto(context, controller),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Prendre une photo'),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: state.isBusy ? null : controller.pickFromGallery,
        icon: const Icon(Icons.photo_library),
        label: const Text('Choisir dans la galerie'),
      ),
    ];
  }

  List<Widget> _analysis(
    BuildContext context,
    WidgetRef ref,
    TerrainAnalysisState state,
    TerrainAnalysisController controller,
  ) {
    final ballRanks = state.ballRanks;
    final possiblyTooWide = ref
        .read(framingCheckerProvider)
        .isPossiblyTooWide(state.detections);
    final closeResult = ref
        .read(ballRankerProvider)
        .isCloseResult(state.ranking);

    return [
      DetectionImage(
        imageFile: File(state.image!.path),
        imageAspectRatio: state.imageAspectRatio,
        detections: state.detections,
        hiddenIndices: state.hiddenIndices,
        jackPosition: state.jackPosition,
        jackConfirmed: state.jackConfirmed,
        ballRanks: ballRanks,
        onTap: (position) => _onImageTap(context, state, controller, position),
      ),
      const SizedBox(height: 8),
      CaptureModeCard(
        guidedCapture: state.guidedCapture,
        tiltDegrees: state.tiltDegrees,
      ),
      const SizedBox(height: 8),
      Text(
        state.jackConfirmed
            ? 'Pincez pour zoomer • Touchez une fausse boule pour l’ignorer'
            : 'Pincez pour zoomer • Touchez le vrai cochonnet pour corriger sa position',
        textAlign: TextAlign.center,
      ),
      if (possiblyTooWide) ...[
        const SizedBox(height: 12),
        const WarningCard(
          icon: Icons.zoom_out_map,
          title: 'Vue possiblement trop large',
          message:
              'Les boules sont petites dans l’image. Rapprochez-vous si possible pour améliorer la précision.',
        ),
      ],
      const SizedBox(height: 16),
      JackValidationCard(
        jackPosition: state.jackPosition,
        jackConfirmed: state.jackConfirmed,
        jackWasDetected: state.jackWasDetected,
        onConfirm: controller.confirmJack,
        onReposition: controller.repositionJack,
      ),
      if (state.jackConfirmed && ballRanks.isNotEmpty) ...[
        const SizedBox(height: 12),
        RankingSummaryCard(rankedCount: ballRanks.length),
        if (closeResult) ...[
          const SizedBox(height: 12),
          const WarningCard(
            icon: Icons.straighten,
            title: 'Résultat très serré',
            message:
                'Possible besoin de revue au mètre : les deux premières boules sont très proches.',
          ),
        ],
      ],
      if (state.ignoredIndices.isNotEmpty) ...[
        const SizedBox(height: 8),
        RestoreIgnoredButton(
          ignoredCount: state.ignoredIndices.length,
          onPressed: controller.restoreIgnoredBalls,
        ),
      ],
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: state.isBusy ? null : controller.pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Changer'),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: state.isBusy ? null : controller.removePhoto,
            tooltip: 'Supprimer la photo',
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      const SizedBox(height: 24),
      const Divider(),
      const SizedBox(height: 16),
      Text(
        'Résultat de l’analyse',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 12),
      AnalysisResultCard(
        analyzing: state.analyzing,
        error: state.error,
        detections: state.detections,
        jackBallIndex: state.jackBallIndex,
        ignoredIndices: state.ignoredIndices,
        ballRanks: ballRanks,
      ),
    ];
  }

  Future<void> _takePhoto(
    BuildContext context,
    TerrainAnalysisController controller,
  ) async {
    final result = await Navigator.of(context).push<PetanqueCameraResult>(
      MaterialPageRoute(builder: (_) => const PetanqueCameraScreen()),
    );
    if (!context.mounted || result == null) return;
    await controller.useCapturedPhoto(result.image, result.tiltDegrees);
  }

  /// Before the jack is confirmed a tap moves it; afterwards a tap on a boule
  /// offers to ignore it as a false positive.
  Future<void> _onImageTap(
    BuildContext context,
    TerrainAnalysisState state,
    TerrainAnalysisController controller,
    Offset position,
  ) async {
    if (!state.jackConfirmed) {
      controller.setJack(position);
      return;
    }

    final detectionIndex = controller.ballAt(position);
    if (detectionIndex == null) return;

    final ignore = await confirmIgnoreDetection(context);
    if (!context.mounted || !ignore) return;
    controller.ignoreBall(detectionIndex);
  }
}
