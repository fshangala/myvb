import 'package:flutter/material.dart';
import 'package:myvb/core/extensions/auth_state.dart';
import 'package:myvb/core/widgets/app_bar.dart';
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
    return Scaffold(
        appBar: appBar(context, 'Join Banking Group'),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Column(
                children: [
                  BankingGroupJoinForm(user: user!),
                ],
              ),
            ],
          ),
        ));
  }
}
