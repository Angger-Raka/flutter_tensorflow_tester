part of 'classifier_bloc.dart';

sealed class ClassifierState {}

class ClassifierInitial extends ClassifierState {
  ClassifierInitial(this.isLoaded) : super();

  final bool isLoaded;
}

class ClassifierPredict extends ClassifierState {
  ClassifierPredict({
    required this.results,
  });

  final DetectionClasses results;
}
