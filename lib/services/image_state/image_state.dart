import 'dart:io';

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

part 'image_state.g.dart';
part 'image_state.freezed.dart';

@freezed
class ImageStateData with _$ImageStateData {
  const factory ImageStateData({
    @Default(null) File? imageFile,
  }) = _ImageStateData;
}

@riverpod
class ImageState extends _$ImageState {
  @override
  ImageStateData build() {
    return const ImageStateData();
  }

  Future<void> setImageData(XFile xfile) async {
    final pngFile = await _convertXFileToPng(xfile);
    state = state.copyWith(imageFile: pngFile);
  }

  Future<File> _convertXFileToPng(XFile xfile) async {
    // Read the XFile into bytes
    final originalBytes = await xfile.readAsBytes();

    // Decode the image (supports various formats including JPG, PNG, etc.)
    img.Image? image = img.decodeImage(originalBytes);
    if (image == null) {
      throw Exception("Error decoding image");
    }

    // Encode the image as PNG
    final pngBytes = img.encodePng(image);

    // Get the directory to save the PNG file
    final directory = await getTemporaryDirectory();
    final filePath = path.join(
        directory.path, '${path.basenameWithoutExtension(xfile.path)}.png');

    // Write the PNG file
    final pngFile = File(filePath);
    await pngFile.writeAsBytes(pngBytes);

    final test = pngFile.path.split(Platform.pathSeparator).last;

    return pngFile;
  }
}
