import 'package:flutter/material.dart';

void goTo(
    {required BuildContext context,
    required String routeName,
    bool permanent = true,
    dynamic arguments}) {
  if (permanent) {
    Navigator.pop(context);
  }
  if (arguments == null) {
    Navigator.of(context).pushNamed(routeName);
  } else {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}
