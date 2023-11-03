import 'package:flutter/material.dart';
import 'package:myvb/banking_groups/create_banking_group.dart';
import 'package:myvb/banking_groups/join_banking_group.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_groups_by_user.dart';
import 'package:myvb/core/widgets/banking_groups_joined.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends AuthState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Home', children: [
      Row(
        children: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateBankingGroup.routeName);
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
      NullFutureRenderer(
          future: user,
          futureRenderer: (userObject) {
            return Column(
              children: [
                BankingGroupsByUser(userId: userObject.id!),
                BankingGroupsJoined(userId: userObject.id!)
              ],
            );
          })
    ]);
  }
}
