import 'package:image_picker/image_picker.dart';

/// Lets the user pick an existing photo.
abstract interface class PhotoPicker {
  Future<XFile?> pickFromGallery();
}

class ImagePickerPhotoPicker implements PhotoPicker {
  const ImagePickerPhotoPicker(this._imagePicker);

  final ImagePicker _imagePicker;

  @override
  Future<XFile?> pickFromGallery() {
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
  }
}
