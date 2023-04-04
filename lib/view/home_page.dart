import 'package:connecta/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase_instances.dart';
import '../service/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(' Connecta'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Container(),
              ),
              ListTile(
                  title: const Text('Sign Out'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    ref.read(authProvider.notifier).logOut();
                  })
            ],
          ),
        ),
      );
    });
  }
}
