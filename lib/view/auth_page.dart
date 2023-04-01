
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                Text(isLogin ? 'Login' : 'Sign Up'),
              ],
            )),
      ),
    );
  }
}
