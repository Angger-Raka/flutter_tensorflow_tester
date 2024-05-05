import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tensorflow_tester/constants/detection_classes.dart';
import 'package:flutter_tensorflow_tester/helper/image_helper.dart';

import '../blocs/blocs.dart';

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
  CameraController? _cameraController;
  DateTime lastPredict = DateTime.now();

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras.first);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void processImage(CameraImage camImage) {
    print("process image");
    final image = ImageHelper.convertYUV420ToImage(camImage);
    context.read<ClassifierBloc>().add(PredictEvent(image: image));
    setState(() {
      lastPredict = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassifierBloc, ClassifierState>(
      listener: (context, state) {
        if (state is ClassifierInitial) {
          if (state.isLoaded) {
          } else {
            _cameraController?.stopImageStream();
          }
        } else if (state is ClassifierPredict) {
          print("Predicted: ${state.results.label}");
        }
      },
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: _cameraController!.value.isInitialized
                    ? CameraPreview(
                        _cameraController!,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Container(
                width: double.maxFinite,
                height: 200,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "Results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<ClassifierBloc, ClassifierState>(
                          builder: (context, state) {
                            if (state is ClassifierPredict) {
                              return Text(
                                state.results.label,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else if (state is ClassifierInitial) {
                              if (!state.isLoaded) {
                                return Text(
                                  "Model not loaded",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Text(state.isLoaded.toString());
                            }
                            return Text(state.toString());
                          },
                        ),
                      ],
                    )),
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _cameraController?.startImageStream((image) {
                                  //make perdiction 1 second after the last prediction
                                  if (DateTime.now()
                                          .difference(lastPredict)
                                          .inSeconds >
                                      1) {
                                    processImage(image);
                                  }
                                });
                              });
                            },
                            child: Text("Start"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}
