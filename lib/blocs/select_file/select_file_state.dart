part of 'select_file_bloc.dart';

@immutable
sealed class SelectFileState {}

final class EmptyFile extends SelectFileState {}

final class FileSelected extends SelectFileState {
  final String path;

  FileSelected(this.path);
}
