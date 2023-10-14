import 'package:flutter/material.dart';

class NotNullFutureRenderer extends StatelessWidget {
  final Future<Object> future;
  final Widget Function(Object object) futureRenderer;
  const NotNullFutureRenderer(
      {super.key, required this.future, required this.futureRenderer});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return futureRenderer(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
