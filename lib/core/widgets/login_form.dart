import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/users/register.dart';

class LoginForm extends StatefulWidget {
  final void Function(User luser)? setUser;
  final bool permanetGoTo;
  const LoginForm({super.key, this.setUser, this.permanetGoTo = true});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(label: Text('E-mail')),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) {
                  if (value == '') {
                    return 'Please enter some value';
                  } else {
                    return null;
                  }
                },
              )),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(label: Text('Password')),
              controller: passwordController,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text('Login'))),
          Container(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                  onPressed: () {
                    goTo(
                        context: context,
                        routeName: RegisterScreen.routeName,
                        permanent: widget.permanetGoTo);
                  },
                  child: const Text('Create Account'))),
        ],
      ),
    );
  }

  void _login() {
    AppUser()
        .login(emailController.text, passwordController.text)
        .then((value) {
      if (value == null) {
        displayRegularSnackBar(context, 'Login failed');
      } else {
        displayRegularSnackBar(context, 'Welcome ${value.displayName}');
      }
      widget.setUser!(value!);
    });
  }
}
