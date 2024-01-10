import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/users/login.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  User? user;

  void afterInit() {}

  @override
  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      user = user;
      if (user == null) {
        displayRegularSnackBar(context, 'User is currently signed out!');
        goTo(context: context, routeName: LoginScreen.routeName);
      }
    });
    afterInit();
  }
}
