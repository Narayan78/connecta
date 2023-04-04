import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecta/models/post.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final crudService = Provider((ref) => CrudService());
final postStream = StreamProvider((ref) => CrudService.getPosts);

class CrudService {
  static final postDb = FirebaseFirestore.instance.collection('posts');

  static Stream<List<Post>> get getPosts {
    return postDb.snapshots().map((event) => event.docs.map((e) {
          final json = e.data();
          return Post(
            like: Like.fromJson(json['like']),
            imageUrl: e['imageUrl'],
            id: e.id,
            title: e['title'],
            detail: e['detail'],
            userId: e['userId'],
            imageId: e['imageId'],
            comments: (json['comments'] as List)
                .map((e) => Comment.fromJson(e))
                .toList(),
          );
        }).toList());
  }

  Future<Either<String, bool>> createPost({
    required String title,
    required String description,
    required String userId,
    //required String userName,
    required XFile image,
  }) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('PostImage/${image.path}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await postDb.add({
        'userId': userId,
        'title': title,
        'detail': description,
        'imageId': image.name,
        //'userName': userName,
        'imageUrl': url,
        'like': {
          'likes': 0,
          'userNames': [],
        },
        'comments': [],
      });
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> updatePost({
    required String id,
    required String title,
    required String description,
    XFile? image,
    String? imageId,
  }) async {
    try {
      if (image == null) {
        await postDb.doc(id).update({
          'title': title,
          'detail': description,
        });
      } else {
        final ref = FirebaseStorage.instance.ref().child('PostImage/$imageId');
        await ref.delete();
        final newRef =
            FirebaseStorage.instance.ref().child('PostImage/${image.name}');
        await newRef.putFile(File(image.path));
        final url = await newRef.getDownloadURL();
        await postDb.doc(id).update({
          'title': title,
          'detail': description,
          'imageId': image.name,
          'imageUrl': url,
        });
      }
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> removePost({
    required String postId,
    required String imageId,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('PostImage/$imageId');
      await ref.delete();
      await postDb.doc(postId).delete();
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> likePost({
    required String postId,
    required int like,
    required String name,
  }) async {
    try {
      await postDb.doc(postId).update({
        'like': {
          'likes': like,
          'userNames': FieldValue.arrayUnion([name]),
        }
      });
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> commentPost({
    required String postId,
    required Comment comment,
  }) async {
    try {
      await postDb.doc(postId).update({
        'comments': FieldValue.arrayUnion([comment.toJson()]),
      });
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
