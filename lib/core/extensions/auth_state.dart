import 'dart:developer';

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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      log(user.toString(),name: 'AuthState');
      if (user == null) {
        goTo(context: context, routeName: LoginScreen.routeName);
      }
      user = user;
    });
    afterInit();
  }
}
