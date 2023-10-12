import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/join_banking_group.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/users/login.dart';
import 'package:myvb/users/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyVB',
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        CreateBankingGroup.routeName: (context) => const CreateBankingGroup(),
        JoinBankingGroup.routeName: (context) => const JoinBankingGroup(),
        ViewBankingGroupScreen.routeName: (context) =>
            const ViewBankingGroupScreen(),
      },
      initialRoute: '/',
    );
  }
}
