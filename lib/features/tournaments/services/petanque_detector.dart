import 'package:tflite_flutter/tflite_flutter.dart';

class PetanqueDetector {
  PetanqueDetector._();

  static final PetanqueDetector instance = PetanqueDetector._();

  Interpreter? _interpreter;
  String? _modelInfo;

  bool get isLoaded => _interpreter != null;

  String get modelInfo =>
      _modelInfo ?? 'Informations du modèle indisponibles';

  Future<void> load() async {
    if (_interpreter != null) {
      return;
    }

    final interpreter = await Interpreter.fromAsset(
      'assets/models/petanque_detector.tflite',
    );

    _interpreter = interpreter;

    final inputTensors = interpreter.getInputTensors();
    final outputTensors = interpreter.getOutputTensors();

    final buffer = StringBuffer();

    buffer.writeln('Entrées : ${inputTensors.length}');

    for (var i = 0; i < inputTensors.length; i++) {
      final tensor = inputTensors[i];

      buffer.writeln();
      buffer.writeln('INPUT $i');
      buffer.writeln('Nom : ${tensor.name}');
      buffer.writeln('Shape : ${tensor.shape}');
      buffer.writeln('Type : ${tensor.type}');
    }

    buffer.writeln();
    buffer.writeln('Sorties : ${outputTensors.length}');

    for (var i = 0; i < outputTensors.length; i++) {
      final tensor = outputTensors[i];

      buffer.writeln();
      buffer.writeln('OUTPUT $i');
      buffer.writeln('Nom : ${tensor.name}');
      buffer.writeln('Shape : ${tensor.shape}');
      buffer.writeln('Type : ${tensor.type}');
    }

    _modelInfo = buffer.toString().trim();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _modelInfo = null;
  }
}