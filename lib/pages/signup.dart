import 'package:flutter/material.dart';
import 'package:myvb/forms/signup_form.dart';
import 'package:myvb/pages/home.dart';

class SignupPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Column(
        children: [
          SignupForm(
            next: HomePage.routeName,
          ),
        ],
      ),
    );
  }
}
