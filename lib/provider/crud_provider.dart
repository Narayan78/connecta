import 'package:connecta/models/common_state.dart';
import 'package:connecta/models/post.dart';
import 'package:connecta/service/crud_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final crudProvider = StateNotifierProvider<CrudProvider , CommonState>((ref) => CrudProvider(CommonState.empty(), ref.watch(crudService)));

class CrudProvider extends StateNotifier<CommonState> {
  final CrudService service;

  CrudProvider(super.state, this.service);

  Future<void> createPost({
    required String title,
    required String description,
    required String userId,
    required XFile image,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.createPost(
        title: title, description: description, userId: userId, image: image);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }

  Future<void> updatePost({
    required String id,
    required String title,
    required String description,
    XFile? image,
    String? imageId,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.updatePost(
      id: id,
      title: title,
      description: description,
      image: image,
      imageId: imageId,
    );
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });

    Future<void> removePost({
      required String postId,
      required String imageId,
    }) async {
      state = state.copyWith(
          isLoad: true, isError: false, isSuccess: false, errText: '');

      final response = await service.removePost(
        postId: postId,
        imageId: imageId,
      );
      response.fold((l) {
        state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errText: l);
      }, (r) {
        state = state.copyWith(
            isLoad: false, isError: false, isSuccess: r, errText: '');
      });
    }
  }

  Future<void> likePost({
    required String postId,
    required int like,
    required String name,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.likePost(
      postId: postId,
      like: like,
      name: name,
    );
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }

  Future<void> commentPost({
    required String postId,
    required Comment comment,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errText: '');

    final response = await service.commentPost(
      postId: postId,
      comment: comment,
    );
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errText: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errText: '');
    });
  }
}
