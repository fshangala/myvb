import 'package:go_router/go_router.dart';
import 'package:myvb/pages/home.dart';
import 'package:myvb/pages/login.dart';
import 'package:myvb/pages/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';
import 'package:myvb/home/home.dart';

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
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 85, 255),
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
  );
}

var router = GoRouter(
  initialLocation: HomeScreen.routeName,
  redirect: (context, state) async {
    if (Supabase.instance.client.auth.currentUser == null &&
        state.matchedLocation != LoginPage.routeName &&
        state.matchedLocation != SignupPage.routeName) {
      return LoginPage.routeName;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: SignupPage.routeName,
      builder: (context, state) => const SignupPage(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://blbrfoqmvcxvbfgdrzxh.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsYnJmb3FtdmN4dmJmZ2RyenhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgwNTg3NDUsImV4cCI6MjAzMzYzNDc0NX0.4NVBnGus28TxwhdEwTDNB8mrzlsUS7UU5bXGjYIG6UU",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
        ),
      ),
      darkTheme: MyThemes.darkTheme,
      title: 'MyVB',
      routerConfig: router,
    );
  }
}
