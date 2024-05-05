import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tensorflow_tester/constants/detection_classes.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../helper/helper.dart';

part 'classifier_event.dart';
part 'classifier_state.dart';

class ClassifierBloc extends Bloc<ClassifierEvent, ClassifierState> {
  ClassifierBloc() : super(ClassifierInitial(false)) {
    on<ClassifierEvent>((event, emit) {});
    on<LoadModelEvent>(_loadModel);
    on<ClearModelEvent>(_clearModel);
    on<PredictEvent>(_predict);
  }

  final ClassifierHelper _classifierHelper = ClassifierHelper();

  Future<void> _loadModel(
    LoadModelEvent event,
    Emitter<ClassifierState> emit,
  ) async {
    await _classifierHelper.loadModel(
      event.filePath,
      options: event.options,
    );
    final isLoaded = _classifierHelper.isModelLoaded();
    emit(ClassifierInitial(isLoaded));
  }

  Future<void> _clearModel(
    ClearModelEvent event,
    Emitter<ClassifierState> emit,
  ) async {
    _classifierHelper.interpreter?.close();
    emit(ClassifierInitial(false));
  }

  Future<void> _predict(
    PredictEvent event,
    Emitter<ClassifierState> emit,
  ) async {
    final results = await _classifierHelper.predict(event.image);
    emit(ClassifierPredict(results: results));
  }
}
