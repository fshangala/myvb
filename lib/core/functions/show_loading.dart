import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return const Dialog(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }));
}
