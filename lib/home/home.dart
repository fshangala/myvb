import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Home'),
    );
  }
}
