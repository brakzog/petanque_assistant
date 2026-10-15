import 'package:flutter/material.dart';

/// Name input with an add button. The field is cleared when [onAdd]
/// returns true.
class AddPlayerField extends StatefulWidget {
  const AddPlayerField({super.key, required this.enabled, required this.onAdd});

  final bool enabled;
  final Future<bool> Function(String name) onAdd;

  @override
  State<AddPlayerField> createState() => _AddPlayerFieldState();
}

class _AddPlayerFieldState extends State<AddPlayerField> {
  final _controller = TextEditingController();

  Future<void> _submit() async {
    final added = await widget.onAdd(_controller.text);
    if (added && mounted) _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Nom du joueur',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: widget.enabled ? _submit : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
