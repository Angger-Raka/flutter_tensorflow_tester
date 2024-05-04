import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tensorflow_tester/blocs/blocs.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFileSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectFileBloc, SelectFileState>(
      listener: (context, state) {
        if (state is FileSelected) {
          setState(() {
            _isFileSelected = true;
          });
        } else {
          setState(() {
            _isFileSelected = false;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Flutter TensorFlow Tester',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<SelectFileBloc, SelectFileState>(
                  builder: (context, state) {
                    if (state is FileSelected) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Text('File selected: ${state.path}'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<SelectFileBloc>()
                                  .add(UnselectedFile());
                            },
                            child: const Text('Unselect file'),
                          )
                        ],
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<SelectFileBloc>().add(SelectFile());
                        },
                        child: const Text('Select file'),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_isFileSelected) {
                      _dialogFileEmpty(context);
                      return;
                    }
                    await availableCameras().then((cameras) {
                      context.push(
                        '/camera-tester',
                        extra: cameras,
                      );
                    });
                  },
                  child: const Text('Test The Model'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.push('/settings');
                  },
                  child: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dialogFileEmpty(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File not selected'),
          content: const Text('Please select a file first'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
