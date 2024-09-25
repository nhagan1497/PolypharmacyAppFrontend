import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/image_state/image_state.dart';
import '../../utilities/logger.dart';
import '../login/blue_box_decoration.dart';

class CameraScreen extends StatefulHookConsumerWidget {
  final String appBarText;
  const CameraScreen({super.key, required this.appBarText});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController?.initialize();
      if (mounted) {
        setState(() {}); // Trigger a rebuild after camera initialization
      }
    } catch (e) {
      logger.e('Error initializing camera.', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageStateActions = ref.watch(imageStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: blueBoxDecoration,
        ),
        centerTitle: true,
        title: Text(
          widget.appBarText,
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
      ),
      body: Center(
        child: cameraController != null && cameraController!.value.isInitialized
            ? CameraPreview(cameraController!,)
            : const CircularProgressIndicator(), // Show loading if not initialized
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (cameraController != null &&
              cameraController!.value.isInitialized) {
            try {
              final imageXFile = await cameraController!.takePicture();
              imageStateActions.setImageData(imageXFile);
              Navigator.of(context).pop();
            } catch (e) {
              print('Error capturing image: $e');
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
