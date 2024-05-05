import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../constants/detection_classes.dart';

class ClassifierHelper {
  Interpreter? _interpreter;

  Interpreter? get interpreter => _interpreter;

  Future<void> loadModel(
    String filePath, {
    InterpreterOptions? options,
  }) async {
    try {
      _interpreter = await Interpreter.fromFile(
        File(filePath),
        options: options ?? InterpreterOptions()
          ..threads = 4,
      );

      _interpreter?.allocateTensors();
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  bool isModelLoaded() => _interpreter != null;

  Future<DetectionClasses> predict(img.Image image) async {
    img.Image resizedImage = img.copyResize(image, width: 150, height: 150);

    // Convert the resized image to a 1D Float32List.
    Float32List inputBytes = Float32List(1 * 150 * 150 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = img.getRed(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = img.getGreen(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = img.getBlue(pixel) / 127.5 - 1.0;
      }
    }

    final output = Float32List(1 * 3).reshape([1, 3]);

    // Reshape to input format specific for model. 1 item in list with pixels 150x150 and 3 layers for RGB
    final input = inputBytes.reshape([1, 150, 150, 3]);

    interpreter?.run(input, output);
    print('Output: $output');
    final predictionResult = output[0] as List<double>;
    double maxElement =
        predictionResult.reduce((double maxElement, double element) {
      return element > maxElement ? element : maxElement;
    });
    print('Prediction result: $predictionResult');
    print('Max element: $maxElement');
    if (maxElement < 0.6) {
      return DetectionClasses.nothing;
    } else {
      return DetectionClasses.values[predictionResult.indexOf(maxElement)];
    }
  }
}
