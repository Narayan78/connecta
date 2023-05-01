import 'package:connecta/firebase_instances.dart';
import 'package:connecta/provider/auth_provider.dart';
import 'package:connecta/service/auth_service.dart';
import 'package:connecta/service/crud_service.dart';
import 'package:connecta/view/add_post.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final us = ref.watch(auth);
      final users = ref.watch(usersStream);
      final user = ref.watch(singleUser(us.currentUser!.uid));
      final posts = ref.watch(postStream);
      return Scaffold(
        appBar: AppBar(
          actions: [
            badge.Badge(
              position:  badge.BadgePosition.topEnd(top: 0, end: 3),
              showBadge: true,
              badgeContent: const Text(
                '5' ,
                style:  TextStyle(color: Colors.black),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_bubble,
                  )),
            )
          ],
          title: const Text(' Connecta'),
          backgroundColor: Colors.grey[800],
        ),
        drawer: Drawer(
            elevation: 300,
            width: 250,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: user.when(
              data: (data) {
                final logUser = data;
                return ListView(
                  shrinkWrap: true,
                  children: [
                    DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(logUser.imageUrl!),
                          ),
                          Text(
                            logUser.firstName!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        logUser.metadata!['email'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      title: const Text('add post'),
                      leading: const Icon(Icons.post_add),
                      onTap: () {
                        Get.to(() => AddPage());
                      },
                    ),
                    ListTile(
                        title: const Text('Sign Out'),
                        leading: const Icon(Icons.logout),
                        onTap: () {
                          ref.read(authProvider.notifier).logOut();
                        })
                  ],
                );
              },
              error: (err, stack) => Center(
                child: Text(err.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 236, 234, 234),
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
                                  backgroundImage:
                                      NetworkImage(data[index].imageUrl!),
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
                ),
              ),
              Expanded(
                  child: posts.when(
                      data: (data) {
                        return Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(data[index].imageUrl),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index].title,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.more_horiz))
                                      ],
                                    ),
                                  ),
                                 
                                  Padding(
                                    padding: const EdgeInsets.only( left: 8.0, top: 5, bottom: 5),
                                    child: Text(
                                      data[index].detail,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      data[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.thumb_up)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.mode_comment_outlined,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.share)),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () =>
                          const Center(child: CircularProgressIndicator())))
            ],
          ),
        ),
      );
    });
  }
}
