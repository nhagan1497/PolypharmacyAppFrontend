import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';

import '../../services/image_state/image_state.dart'; // For base64 encoding

class CameraPreviewScreen extends StatefulHookConsumerWidget {
  const CameraPreviewScreen({super.key});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends ConsumerState<CameraPreviewScreen> {
  CameraController? cameraController; // Make nullable

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose(); // Use null check
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
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageStateActions = ref.watch(imageStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Camera Preview")),
      body: Center(
        child: cameraController != null && cameraController!.value.isInitialized
            ? CameraPreview(cameraController!)
            : const CircularProgressIndicator(), // Show loading if not initialized
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (cameraController != null && cameraController!.value.isInitialized) {
            try {
              final image = await cameraController!.takePicture();
              imageStateActions.setImage(image);
              imageStateActions
                  .setImageBase64(base64Encode(await image.readAsBytes()));
              if (mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              print('Error capturing image: $e');
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
