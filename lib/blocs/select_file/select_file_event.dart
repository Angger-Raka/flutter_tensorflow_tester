part of 'select_file_bloc.dart';

@immutable
sealed class SelectFileEvent {}

final class SelectFile extends SelectFileEvent {}

class UnselectedFile extends SelectFileEvent {}
