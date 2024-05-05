part of 'classifier_bloc.dart';

@immutable
sealed class ClassifierEvent {}

class LoadModelEvent extends ClassifierEvent {
  final String filePath;
  final InterpreterOptions? options;

  LoadModelEvent({
    required this.filePath,
    this.options,
  });
}

class ClearModelEvent extends ClassifierEvent {}

class PredictEvent extends ClassifierEvent {
  final img.Image image;

  PredictEvent({
    required this.image,
  });
}
