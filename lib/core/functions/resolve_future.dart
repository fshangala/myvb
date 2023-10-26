import 'package:flutter/material.dart';
import 'package:myvb/core/functions/display_regular_snackbar.dart';
import 'package:myvb/core/functions/show_loading.dart';

void resolveFuture<T>(
    BuildContext context, Future<T> future, void Function(T value) callback) {
  showLoading(context);
  future.then((value) {
    Navigator.pop(context);
    if (value == null) {
      displayRegularSnackBar(context, 'Failed!');
    } else {
      callback(value);
    }
  }).onError((error, stackTrace) {
    Navigator.pop(context);
    displayRegularSnackBar(context, 'Error: $error');
  });
}
