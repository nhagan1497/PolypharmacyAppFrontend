import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_state.g.dart';
part 'image_state.freezed.dart';

@freezed
class ImageStateData with _$ImageStateData{
  const factory ImageStateData(
      {
    @Default(null) XFile? image,
    @Default(null) String? imageBase64,
}) =
  _ImageStateData;
}

@riverpod
class ImageState extends _$ImageState {
  @override
  ImageStateData build() {
    return const ImageStateData();
  }

  void setImage(XFile image) {
    state = state.copyWith(image: image);
  }

  void setImageBase64(String imageBase64) {
    state = state.copyWith(imageBase64: imageBase64);
  }
}
