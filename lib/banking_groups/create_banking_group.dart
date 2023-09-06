import 'package:flutter/material.dart';
import 'package:myvb/core/widgets/app_bar.dart';

class CreateBankingGroup extends StatefulWidget {
  final String userId;
  const CreateBankingGroup({super.key, required this.userId});
  static String routeName = '/banking_group/create';

  @override
  State<StatefulWidget> createState() {
    return _CreateBankingGroupState();
  }
}

class _CreateBankingGroupState extends State<CreateBankingGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Create Banking Group'),
    );
  }
}
