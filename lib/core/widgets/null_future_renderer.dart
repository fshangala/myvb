import 'package:flutter/material.dart';

class NullFutureRenderer<T> extends StatelessWidget {
  final Future<T?> future;
  final Widget Function(T object) futureRenderer;
  const NullFutureRenderer(
      {super.key, required this.future, required this.futureRenderer});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return futureRenderer(snapshot.data as T);
          } else {
            return const Center(
              child: Text('Nothing to show'),
            );
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
