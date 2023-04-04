import 'package:connecta/provider/auth_provider.dart';
import 'package:connecta/view/auth_page.dart';
import 'package:connecta/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final authData = ref.watch(userOnline);

        return authData.when(
          data: (data) {
            if (data == null) {
              return AuthPage();
            } else {
              return const HomePage();
            }
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
