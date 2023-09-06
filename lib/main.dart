import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/join_banking_group.dart';
import 'package:myvb/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  dynamic userId = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyVB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(
              userId: userId,
            ),
        CreateBankingGroup.routeName: (context) =>
            CreateBankingGroup(userId: userId),
        JoinBankingGroup.routeName: (context) =>
            JoinBankingGroup(userId: userId),
      },
      initialRoute: '/',
    );
  }
}
