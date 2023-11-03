import 'package:flutter/material.dart';

class NullFutureRenderer<T> extends StatelessWidget {
  final Future<T?> future;
  final Widget Function(T object) futureRenderer;
  final Widget Function()? nullRenderer;
  const NullFutureRenderer(
      {super.key,
      required this.future,
      required this.futureRenderer,
      this.nullRenderer});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return futureRenderer(snapshot.data as T);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (nullRenderer != null) {
              return nullRenderer!();
            } else {
              return const Center(
                child: Text('Nothing to show'),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
