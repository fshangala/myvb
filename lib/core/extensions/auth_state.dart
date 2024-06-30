import 'package:flutter/material.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  User? user;
  final supabase = Supabase.instance.client;

  void afterInit() {}

  @override
  initState() {
    super.initState();
    user = supabase.auth.currentUser;
    if (user == null) {
      /* goTo(
        context: context,
        routeName: LoginScreen.routeName,
        permanent: true,
      ); */
    }
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
