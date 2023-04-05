import 'dart:io';

import 'package:connecta/common_widget/snack_show.dart';
import 'package:connecta/helper/helper_provider.dart';
import 'package:connecta/provider/crud_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AddPage extends ConsumerWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(crudProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showError(next.errText.toString());
      } else if (next.isSuccess) {
        SnackShow.showSuccess('Success');
      }
    });
    final auth = ref.watch(crudProvider);
    final image = ref.watch(imageProvider);

    return WillPopScope(
      onWillPop: () async {
        if (auth.isLoad) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                const Text('Add your Post'),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 7,
                ),
                InkWell(
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Choose From',
                      content: Column(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(imageProvider.notifier)
                                    .selectImage(true);
                              },
                              child: const Text('Camera')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(imageProvider.notifier)
                                    .selectImage(false);
                              },
                              child: const Text('Gallery')),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // full height of the screen
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 176, 170, 170)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: image == null
                          ? const Center(child: Text('No Image Selected'))
                          : Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: auth.isLoad
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (image == null) {
                              SnackShow.showError('Please select image');
                            } else {
                              ref.read(crudProvider.notifier).createPost(
                                    description:
                                        descriptionController.text.trim(),
                                    image: image,
                                    title: titleController.text.trim(),
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                  );
                            }
                          }
                        },
                  child: const Text('Post'),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
