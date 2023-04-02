import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final loginProvider = StateNotifierProvider<LoginProvider, bool>((ref) {
  return LoginProvider(true);
});

class LoginProvider extends StateNotifier<bool> {
  LoginProvider(super.state);

  void change() {
    state = !state;
  }
}

final passHide = StateProvider.autoDispose<bool>((ref) =>true );

final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>(
    (ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);
  final ImagePicker imagePicker = ImagePicker();
  void selectImage(bool isCamera) async {
    if (isCamera) {
      state = await imagePicker.pickImage(source: ImageSource.camera);
    } else {
      state = await imagePicker.pickImage(source: ImageSource.gallery);
    }
  }
}

final modeProvider =
    StateNotifierProvider.autoDispose<ModeProvider, AutovalidateMode>(
        (ref) => ModeProvider(AutovalidateMode.disabled));

class ModeProvider extends StateNotifier<AutovalidateMode> {
  ModeProvider(super.state);

  void changeMode() {
    state = AutovalidateMode.onUserInteraction;
  }
}
