import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../common_widget/snack_show.dart';
import '../helper/helper_provider.dart';
import '../provider/auth_provider.dart';

class AuthPage extends ConsumerWidget {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showError(next.errText);
      } else if (next.isSuccess) {
        SnackShow.showSuccess(next.errText);
      }
    });
    final auth = ref.watch(authProvider);
    final isLogin = ref.watch(loginProvider);
    final mode = ref.watch(modeProvider);
    final image = ref.watch(imageProvider);
    final passHidden = ref.watch(passHide);
    return Scaffold(
      body: Form(
          autovalidateMode: mode,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                if (isLogin)
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                  ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // userName field.............
                if (!isLogin)
                  TextFormField(
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.next,
                    controller: userNameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username field can\'t be empty';
                      } else if (value.length < 6) {
                        return 'Username must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),

                // email field.............

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'please provide valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // password field.............

                TextFormField(
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: passwordController,
                  obscureText: passHidden,
                  decoration: InputDecoration(
                      hintText: 'password',
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ref.read(passHide.notifier).state =
                              !ref.read(passHide.notifier).state;
                        },
                        icon: Icon(passHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password field can't be empty";
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                // confirm password field.............
                const SizedBox(
                  height: 20,
                ),
                if (!isLogin)
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: passHidden,
                    decoration: InputDecoration(
                        hintText: 'confirm password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () {
                            ref.read(passHide.notifier).state =
                                !ref.read(passHide.notifier).state;
                          },
                          icon: Icon(passHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password field can't be empty";
                      } else if (value.trim() !=
                          passwordController.text.trim()) {
                        return 'Pasword doesn\'t match';
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),

                // image selection field.............
                if (!isLogin)
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
                          ));
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: image == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                              ),
                            )
                          : Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                // login button.............

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed:  auth.isLoad
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.save();
                   
                              if (_formKey.currentState!.validate()) {
                                if (isLogin) {
                                  ref.read(authProvider.notifier).userLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                                    
                                } else if (image == null) {
                                  SnackShow.showError('Please select an image');
                                } else {
                                  ref.read(authProvider.notifier).signUp(
                                      userName: userNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      image: image);
                                }
                              }else{
                                   ref.read(modeProvider.notifier).changeMode();
                              }
                            },
                    child: auth.isLoad
                        ? const CircularProgressIndicator()
                        : Text(
                            isLogin ? 'Login' : 'Sign Up',
                          )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? 'Don\'t have an account?'
                        : 'Already have an account?'),
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                          ref.read(loginProvider.notifier).change();
                        },
                        child: Text(isLogin ? 'Sign Up' : 'Login')),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
