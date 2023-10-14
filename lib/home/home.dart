import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/join_banking_group.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_bar.dart';
import 'package:myvb/core/widgets/banking_groups_by_user.dart';
import 'package:myvb/core/widgets/banking_groups_joined.dart';
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

  @override
  void initState() {
    super.initState();
    user = User.loggedInUser();
    user.then((value) {
      if (value == null) {
        goTo(context: context, routeName: LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Home'),
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
                  TextButton(
                      onPressed: () {
                        goTo(
                            context: context,
                            routeName: JoinBankingGroup.routeName,
                            permanent: false);
                      },
                      child: const Text('Join')),
                ],
              ),
              FutureBuilder(
                  future: user,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Column(
                          children: [
                            BankingGroupsByUser(userId: snapshot.data!.id!),
                            BankingGroupsJoined(
                                username: snapshot.data!.username)
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text('Nothing to show'),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }))
            ],
          )),
    );
  }
}
