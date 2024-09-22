import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_state.g.dart';
part 'image_state.freezed.dart';

@freezed
class ImageStateData with _$ImageStateData {
  const factory ImageStateData(
      {@Default(null) XFile? imageXFile,
      @Default(null) MultipartFile? imageMultipartFile}) = _ImageStateData;
}

@riverpod
class ImageState extends _$ImageState {
  @override
  ImageStateData build() {
    return const ImageStateData();
  }

  void setImageData(XFile imageXFile, MultipartFile imageMultipart) {
    state = state.copyWith(
        imageXFile: imageXFile, imageMultipartFile: imageMultipart);
  }
}
