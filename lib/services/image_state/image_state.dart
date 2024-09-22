import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  void setImageData(File imageFile) {
    state = state.copyWith(imageFile: imageFile);
  }
}
