import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/pages/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginForm extends StatefulWidget {
  final void Function(User luser)? setUser;
  final String next;
  const LoginForm({super.key, required this.next, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  var supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');

  Future<AuthResponse> _loginWithPassword() async {
    return await supabase.auth.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void _login() {
    resolveFuture(
      context,
      _loginWithPassword(),
      (value) {
        log(value.user.toString(), name: 'Logged In');
        if (value.user == null) {
          //
        } else {
          context.go(widget.next);
        }
      },
    );
  }

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
              child: const Text('Login'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                context.go(SignupPage.routeName);
              },
              child: const Text('Create Account'),
            ),
          ),
        ],
      ),
    );
  }
}
