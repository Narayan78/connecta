import 'package:connecta/firebase_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/common_state.dart';
import '../service/auth_service.dart';





final userStream = StreamProvider((ref) => ref.read(auth).authStateChanges());

final authProvider = StateNotifierProvider<AuthProvider, CommonState>(
  (ref) => AuthProvider(
    CommonState.empty(),
    ref.watch(authServiceProvider),
  ),
);

class AuthProvider extends StateNotifier<CommonState> {
  final AuthService service;

  AuthProvider(
    super.state,
    this.service,
  );

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.userLogin(email: email, password: password);

    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    required XFile image,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.userSignUp(
      userName: userName,
      email: email,
      password: password,
      image: image,
    );

    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }

  Future<void> logOut() async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.logOut();

    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }
}
