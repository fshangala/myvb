import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class JoinBankingGroup extends StatefulWidget {
  const JoinBankingGroup({super.key});

  static const routeName = 'banking_group/join';

  @override
  State<StatefulWidget> createState() {
    return _JoinBankingGroupState();
  }
}

class _JoinBankingGroupState extends State<JoinBankingGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Join Banking Group'),
    );
  }
}
