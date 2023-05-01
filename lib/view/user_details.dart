import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;



class UserDetails extends ConsumerWidget {

 final types.User user;
UserDetails({required this.user});

  @override
  Widget build(BuildContext context , WidgetRef ref) {


    return const Placeholder();
  }
}