import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final profilePhotoProvider =
    NotifierProvider.autoDispose<ProfilePhotoNotifier, File>(
        ProfilePhotoNotifier.new);

class ProfilePhotoNotifier extends AutoDisposeNotifier<File> {
  @override
  File build() {
    return File('');
  }

  void uploadPhoto(String image) {
    state = File(image);
  }

  Future<void> takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    ref.read(profilePhotoProvider.notifier).uploadPhoto(pickedImage.path);
  }

  Future<void> pickPhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    ref.read(profilePhotoProvider.notifier).uploadPhoto(pickedImage.path);
  }
}
