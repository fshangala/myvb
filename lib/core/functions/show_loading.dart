import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/loading_dialog.dart';

void showLoading(BuildContext context, {String message = "Loading"}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return LoadingDialog(messageText: message);
      }));
}
