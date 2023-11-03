import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/users/login.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  late Future<User?> user;

  void afterInit() {}

  @override
  initState() {
    super.initState();
    user = User().loggedInUser();
    user.then((value) {
      if (value == null) {
        goTo(context: context, routeName: LoginScreen.routeName);
      }
    });
    afterInit();
  }
}
