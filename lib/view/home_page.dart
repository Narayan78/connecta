import 'package:connecta/provider/auth_provider.dart';
import 'package:connecta/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final users = ref.watch(usersStream);
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 236, 234, 234),
                ),
                height: 120,
                child: users.when(
                  data: (data) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          
                          print(data[index].imageUrl);
                         
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(data[index].imageUrl!),
                                ),
                                Text(data[index].firstName!)
                              ],
                            ),
                          );
                        });
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ))
          ]),
        ),
      );
    });
  }
}
