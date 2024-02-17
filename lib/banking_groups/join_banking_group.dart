import 'package:flutter/material.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_scaffold.dart';
import 'package:myvb/core/widgets/banking_group_join_form.dart';

class JoinBankingGroup extends StatefulWidget {
  const JoinBankingGroup({super.key});

  static const routeName = 'banking_group/join';

  @override
  State<StatefulWidget> createState() {
    return _JoinBankingGroupState();
  }
}

class _JoinBankingGroupState extends AuthState<JoinBankingGroup> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Join Banking Group',
        onRefresh: () {},
        children: [
          Column(
            children: [
              userWidget((luser) => BankingGroupJoinForm(user: luser)),
            ],
          ),
        ]);
  }
}
