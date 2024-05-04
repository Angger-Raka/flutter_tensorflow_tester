import 'package:file_picker/file_picker.dart';

class FileHelper {
  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }
    return result.files.single.name;
  }

  Future<void> clearFile() async {
    await FilePicker.platform.clearTemporaryFiles();
  }
}
