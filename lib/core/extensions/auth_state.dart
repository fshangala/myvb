import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/users/login.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  User? user;

  void afterInit() {}

  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? luser) {
      if (luser == null) {
        goTo(context: context, routeName: LoginScreen.routeName);
      }
      if (mounted) {
        setState(() {
          user = luser;
        });
      } else {
        user = luser;
      }
    });
    afterInit();
  }

  Widget userWidget(Widget Function(User luser) renderer) {
    if (user == null) {
      return const Text('Please login!');
    } else {
      return renderer(user!);
    }
  }
}
