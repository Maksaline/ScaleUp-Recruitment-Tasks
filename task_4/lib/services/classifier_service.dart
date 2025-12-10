import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierService {
  static const String _modelPath = 'assets/food_101_model.tflite';
  static const String _labelsPath = 'assets/food_101_labels.txt';
  static const int _inputSize = 224;

  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;
  late List<int> _outputShape;
  late TensorType _inputType;
  late TensorType _outputType;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);

      _outputShape = outputTensor.shape;
      _inputType = inputTensor.type;
      _outputType = outputTensor.type;

      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize classifier: $e');
    }
  }


  Future<ClassificationResult> classifyImage(File imageFile) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Classifier not initialized');
    }

    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
    final input = _prepareInput(resizedImage);

    final numClasses = _outputShape.length > 1 ? _outputShape[1] : _outputShape[0];
    final output = _prepareOutput(numClasses);

    _interpreter!.run(input, output);

    final probabilities = output[0] as List;
    int maxIndex = 0;
    double maxValue = (probabilities[0] as num).toDouble();

    for (int i = 1; i < probabilities.length; i++) {
      final value = (probabilities[i] as num).toDouble();
      if (value > maxValue) {
        maxValue = value;
        maxIndex = i;
      }
    }

    double confidence = maxValue;
    if (_outputType == TensorType.uint8) {
      confidence = maxValue / 255.0;
    }

    final label = maxIndex < _labels.length ? _labels[maxIndex] : 'Unknown';

    return ClassificationResult(
      label: label,
      confidence: confidence,
      index: maxIndex,
    );
  }

  dynamic _prepareInput(img.Image image) {
    if (_inputType == TensorType.uint8) {
      return List.generate(
        1,
            (_) => List.generate(
          _inputSize,
              (y) => List.generate(
            _inputSize,
                (x) {
              final pixel = image.getPixel(x, y);
              return [
                pixel.r.toInt(),
                pixel.g.toInt(),
                pixel.b.toInt(),
              ];
            },
          ),
        ),
      );
    } else {
      return List.generate(
        1,
            (_) => List.generate(
          _inputSize,
              (y) => List.generate(
            _inputSize,
                (x) {
              final pixel = image.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );
    }
  }


  dynamic _prepareOutput(int numClasses) {
    if (_outputType == TensorType.uint8) {
      return List<List<int>>.generate(
        1,
            (_) => List<int>.filled(numClasses, 0),
      );
    } else {
      return List<List<double>>.generate(
        1,
            (_) => List<double>.filled(numClasses, 0),
      );
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}

class ClassificationResult {
  final String label;
  final double confidence;
  final int index;

  ClassificationResult({
    required this.label,
    required this.confidence,
    required this.index,
  });

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(2)}%';
}
