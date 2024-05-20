import 'package:flutter/material.dart';

class NullFutureRenderer<T> extends StatelessWidget {
  final Future<T?> future;
  final Widget Function(T object) futureRenderer;
  final Widget Function()? nullRenderer;
  final String messageText;
  const NullFutureRenderer(
      {super.key,
      required this.future,
      required this.futureRenderer,
      this.nullRenderer,
      this.messageText = "Loading"});

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
          return Center(
              child: Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    messageText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ));
        }
      },
    );
  }
}
