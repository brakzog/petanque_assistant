import 'package:image_picker/image_picker.dart';

/// Lets the user take a photo or pick an existing one.
abstract interface class PhotoPicker {
  Future<XFile?> pickFromGallery();

  Future<XFile?> takePhoto();
}

class ImagePickerPhotoPicker implements PhotoPicker {
  const ImagePickerPhotoPicker(this._imagePicker);

  static const _imageQuality = 95;

  final ImagePicker _imagePicker;

  @override
  Future<XFile?> pickFromGallery() => _pick(ImageSource.gallery);

  @override
  Future<XFile?> takePhoto() => _pick(ImageSource.camera);

  Future<XFile?> _pick(ImageSource source) {
    return _imagePicker.pickImage(source: source, imageQuality: _imageQuality);
  }
}
