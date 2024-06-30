import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/resolve_future.dart';
import 'package:myvb/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupForm extends StatefulWidget {
  final void Function(dynamic user)? setUser;
  final String next;
  const SignupForm({super.key, required this.next, this.setUser});

  @override
  State<StatefulWidget> createState() {
    return _SignupFormState();
  }
}

class _SignupFormState extends State<SignupForm> {
  var supabase = Supabase.instance.client;
  var appUser = AppUser();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController(text: '');
  var firstNameController = TextEditingController(text: '');
  var lastNameController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');

  Future<AuthResponse> _registerUser() async {
    var res = await supabase.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
      data: {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
      },
    );
    return res;
  }

  void _register() {
    resolveFuture(
      context,
      _registerUser(),
      (value) {
        log(value.user.toString(), name: 'Registered User');
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == '') {
                  return 'Username cannot be empty!';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(label: Text('First name')),
              controller: firstNameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == '') {
                  return 'First name cannot be empty!';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(label: Text('Last name')),
              controller: lastNameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == '') {
                  return 'Last name cannot be empty!';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(label: Text('Password')),
              controller: passwordController,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
              child: const Text('Register'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                context.go(LoginPage.routeName);
              },
              child: const Text('Already have an account? Login'),
            ),
          ),
        ],
      ),
    );
  }
}
