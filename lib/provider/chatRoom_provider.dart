import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageStream = StreamProvider.family(
    (ref, types.Room room) => FirebaseChatCore.instance.messages(room));

final roomProvider = Provider((ref) => RoomProvider());

class RoomProvider {
  Future<types.Room?> createRoom(types.User user) async {
    try {
      final response = await FirebaseChatCore.instance.createRoom(user);
      return response;
    } catch (err) {
      return null;
    }
  }
}
