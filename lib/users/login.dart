import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Login'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(),
      ),
    );
  }
}
