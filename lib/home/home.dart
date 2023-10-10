import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/users/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  late Future<User?> user;
  Future<List<BankingGroup>> bankingGroups = Future.value(<BankingGroup>[]);

  @override
  void initState() {
    super.initState();
    user = User.loggedInUser();
    user.then((value) {
      if (value == null) {
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginScreen.routeName);
      } else {
        bankingGroups = BankingGroup.getUserBankingGroups(value.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Home'),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, CreateBankingGroup.routeName);
                      },
                      child: const Text('Create')),
                  TextButton(onPressed: () {}, child: const Text('Join')),
                ],
              ),
              FutureBuilder(
                  future: bankingGroups,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: _bankingGroupsListTiles(snapshot.data!),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }))
            ],
          )),
    );
  }

  List<ListTile> _bankingGroupsListTiles(List<BankingGroup> bankingGroups) {
    return bankingGroups
        .map((e) => ListTile(
              title: Text(e.name),
            ))
        .toList();
  }
}
