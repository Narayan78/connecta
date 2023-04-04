import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../firebase_instances.dart';

final usersStream =
    StreamProvider.autoDispose((ref) => ref.read(chatCore).users());

final singleUser =
    StreamProvider.family((ref, String id) => AuthService.getUser(id));

final authServiceProvider = Provider((ref) => AuthService(
    auth: ref.watch(auth),
    chatCore: ref.watch(chatCore),
    messaging: ref.watch(msg),
    storage: ref.watch(storage)));

class AuthService {
  final FirebaseAuth auth;
  final FirebaseMessaging messaging;
  final FirebaseChatCore chatCore;
  final FirebaseStorage storage;

  AuthService({
    required this.auth,
    required this.chatCore,
    required this.messaging,
    required this.storage,
  });

  static final userDb = FirebaseFirestore.instance.collection('users');

  static Stream<types.User> getUser(String userId) {
    return userDb.doc(userId).snapshots().map((event) {
      final json = event.data() as Map<String, dynamic>;
      return types.User(
        id: event.id,
        firstName: json['firstName'],
        metadata: {
          'email': json['metadata']['email'],
          'token': json['metadata']['token'],
        },
        imageUrl: json['imageUrl'],
      );
    });
  }

  Future<Either<String, bool>> userLogin(
      {required String email, required String password}) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final token = await messaging.getToken();
      await userDb.doc(response.user!.uid).update({
        'metadata': {
          'token': token,
          'email': email,
        },
      });
      return const Right(true);
    } on FirebaseAuthException catch (err) {
      return left(err.message.toString());
    } catch (err) {
      return left(err.toString());
    }
  }

  Future<Either<String, bool>> userSignUp({
    required String email,
    required String password,
    required String userName,
    required XFile image,
  }) async {
    try {
      final ref = storage.ref().child('UserImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      final token = await messaging.getToken();
      final response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      chatCore.createUserInFirestore(
        types.User(
            id: response.user!.uid,
            firstName: userName,
            imageUrl: url,
            metadata: {
              'email': email,
              'token': token,
            }),
      );
      return const Right(true);
    } on FirebaseAuthException catch (err) {
      return left(err.message.toString());
    } on FirebaseException catch (err) {
      return left(err.toString());
    } catch (err) {
      return left(err.toString());
    }
  }

  Future<Either<String, bool>> logOut() async {
    try {
      await auth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (err) {
      return left(err.message.toString());
    } catch (err) {
      return left(err.toString());
    }
  }
}
