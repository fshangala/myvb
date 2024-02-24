import 'package:flutter/material.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/users/profile.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    title: Text('MyVB - $title'),
    actions: [
      IconButton(
        onPressed: () {
          goTo(
              context: context,
              routeName: HomeScreen.routeName,
              permanent: true);
        },
        icon: const Icon(Icons.home),
      ),
      IconButton(
        onPressed: () {
          goTo(
              context: context,
              routeName: ProfileScreen.routeName,
              permanent: false);
        },
        icon: const Icon(Icons.person),
      )
    ],
  );
}
