/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/register_form.dart';
import 'package:myvb/home/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routeName = '/register';

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Register'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [RegisterForm()],
        ),
      ),
    );
  }

  void setUser(User luser) {
    Navigator.pop(context);
    Navigator.pushNamed(context, HomeScreen.routeName);
  }
}
 */