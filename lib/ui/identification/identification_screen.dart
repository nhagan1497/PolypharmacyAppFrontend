import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IdentificationScreen extends HookWidget {
  const IdentificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // State to manage the CameraController and its initialization
    final cameraController = useState<CameraController?>(null);
    final isCameraInitialized = useState(false);

    // useEffect to initialize the camera only once when the widget is first built
    useEffect(() {
      Future<void> initCamera() async {
        try {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;

          cameraController.value = CameraController(
            firstCamera,
            ResolutionPreset.high,
          );

          await cameraController.value!.initialize();
          isCameraInitialized.value = true;
        } catch (e) {
          print('Error initializing camera: $e');
        }
      }

      initCamera();

      // Dispose the controller when the widget is disposed
      return () => cameraController.value?.dispose();
    }, []); // The empty array ensures this runs only once

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Use Pill ID artificial intelligence to analyze pictures of any medication you may have dropped or spilled',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isCameraInitialized.value
                  ? () {
                // Navigate to camera preview screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPreviewScreen(
                      cameraController: cameraController.value!,
                    ),
                  ),
                );
              }
                  : null, // Disable button if the camera is not initialized
              child: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraPreviewScreen extends HookWidget {
  final CameraController cameraController;

  const CameraPreviewScreen({required this.cameraController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Preview")),
      body: Center(
        child: CameraPreview(cameraController),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final image = await cameraController.takePicture();
            // Handle the captured image (e.g., display it or analyze it)
          } catch (e) {
            print('Error capturing image: $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
