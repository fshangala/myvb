import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/register_form.dart';

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
      appBar: appBar('Register'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [RegisterForm()],
        ),
      ),
    );
  }
}
