import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Login'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            LoginForm(setUser: setUser),
          ],
        ),
      ),
    );
  }

  void setUser(User luser) {
    setState(() {
      user = luser;
    });
  }
}