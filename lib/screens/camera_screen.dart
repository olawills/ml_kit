import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ml_kit/main.dart';
import 'package:ml_kit/screens/detail_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController _controller;

  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print('Controller is not initialized');
      return null;
    }
    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print('Processing is in progres.......');
      return null;
    }

    try {
      // Turning off the camera
      _controller.setFlashMode(FlashMode.off);

      // Returns the image in cross-platform file abstraction

      final XFile file = await _controller.takePicture();

      // Retrieve
      imagePath = file.path;
    } on CameraException catch (e) {
      print('camera Exception $e');
      return null;
    }
    return imagePath;
  }

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Image Recognition App';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text('click me'),
                      onPressed: () async {
                        await _takePicture().then(
                          (String? path) {
                            if (path != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    imagePath: path,
                                  ),
                                ),
                              );
                            } else {
                              print('Image path not found!');
                            }
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
