import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tensorflow_tester/helper/helper.dart';

part 'select_file_event.dart';
part 'select_file_state.dart';

class SelectFileBloc extends Bloc<SelectFileEvent, SelectFileState> {
  SelectFileBloc() : super(EmptyFile()) {
    on<SelectFile>(selectFile);
    on<UnselectedFile>(unselectFile);
  }

  final FileHelper fileHelper = FileHelper();

  Future<void> selectFile(
      SelectFile event, Emitter<SelectFileState> emit) async {
    final path = await fileHelper.pickFile();
    if (path == null) {
      return;
    }
    emit(FileSelected(path));
  }

  Future<void> unselectFile(
    UnselectedFile event,
    Emitter<SelectFileState> emit,
  ) async {
    await fileHelper.clearFile();
    emit(EmptyFile());
  }
}
