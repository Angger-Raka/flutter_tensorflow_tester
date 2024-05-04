import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraTesterPage extends StatefulWidget {
  const CameraTesterPage({
    required this.cameras,
    super.key,
  });

  final List<CameraDescription> cameras;

  @override
  State<CameraTesterPage> createState() => _CameraTesterPageState();
}

class _CameraTesterPageState extends State<CameraTesterPage> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras.first);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              child: _cameraController.value.isInitialized
                  ? CameraPreview(
                      _cameraController,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Container(
              width: double.maxFinite,
              height: 200,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}
