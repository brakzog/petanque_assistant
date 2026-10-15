import 'package:flutter/material.dart';

class RestoreIgnoredButton extends StatelessWidget {
  const RestoreIgnoredButton({
    super.key,
    required this.ignoredCount,
    required this.onPressed,
  });

  final int ignoredCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final plural = ignoredCount > 1 ? 's' : '';
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.restore),
      label: Text('Réafficher $ignoredCount détection$plural ignorée$plural'),
    );
  }
}
