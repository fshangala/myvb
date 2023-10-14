import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/user.dart';
import 'package:myvb/core/functions/go_to.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/null_future_renderer.dart';
import 'package:myvb/users/login.dart';

class InvestBankingGroup extends StatefulWidget {
  static const routeName = '/banking-group/invest';
  const InvestBankingGroup({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InvestBankingGroupState();
  }
}

class _InvestBankingGroupState extends State<InvestBankingGroup> {
  late Future<User?> user;

  @override
  initState() {
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
    return AppScaffold(title: 'Invest', children: [
      NullFutureRenderer<User>(
          future: user,
          futureRenderer: (userObject) {
            return const Column(
              children: [],
            );
          }),
    ]);
  }
}
