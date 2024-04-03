import 'package:firebase_core/firebase_core.dart';
import 'package:myvb/pages/transaction_tokens.dart';
import 'package:myvb/users/profile.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/invest_banking_group.dart';
import 'package:myvb/banking_groups/join_banking_group.dart';
import 'package:myvb/banking_groups/screen_repay_loan.dart';
import 'package:myvb/banking_groups/screen_request_loan.dart';
import 'package:myvb/banking_groups/view_banking_group.dart';
import 'package:myvb/banking_groups/view_banking_group_member.dart';
import 'package:myvb/home/home.dart';
import 'package:myvb/users/login.dart';
import 'package:myvb/users/register.dart';

class MyThemes {
  static const primary = Colors.blue;
  static final primaryColor = Colors.blue.shade300;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColorDark: primaryColor,
    colorScheme: const ColorScheme.dark(primary: primary),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 0, 85, 255),
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
        ),
      ),
      darkTheme: MyThemes.darkTheme,
      title: 'MyVB',
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        CreateBankingGroup.routeName: (context) => const CreateBankingGroup(),
        JoinBankingGroup.routeName: (context) => const JoinBankingGroup(),
        ViewBankingGroupScreen.routeName: (context) =>
            const ViewBankingGroupScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ViewBankingGroupMemberScreen.routeName: (context) =>
            const ViewBankingGroupMemberScreen(),
        InvestBankingGroup.routeName: (context) => const InvestBankingGroup(),
        ScreenRequestLoan.routeName: (context) => const ScreenRequestLoan(),
        RepayLoanScreen.routeName: (context) => const RepayLoanScreen(),
        TransactionTokensPage.routeName: (context) =>
            const TransactionTokensPage(),
      },
      initialRoute: '/',
    );
  }
}
