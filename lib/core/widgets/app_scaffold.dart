import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AppScaffold({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}
