import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myvb/forms/login_form.dart';
import 'package:myvb/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () {
              context.go(HomePage.routeName);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            LoginForm(next: HomePage.routeName),
          ],
        ),
      ),
    );
  }
}
