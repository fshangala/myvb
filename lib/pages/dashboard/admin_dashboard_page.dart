import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  static const routeName = "admin/dashboard";
  @override
  State<StatefulWidget> createState() {
    return _AdminDashboardPage();
  }
}

class _AdminDashboardPage extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      onRefresh: () {},
      children: [],
    );
  }
}
