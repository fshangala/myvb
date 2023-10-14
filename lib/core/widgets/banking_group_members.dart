import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';

class BankingGroupMembers extends StatefulWidget {
  final BankingGroup bankingGroup;
  const BankingGroupMembers({super.key, required this.bankingGroup});

  @override
  State<StatefulWidget> createState() {
    return _BankingGroupMembersState();
  }
}

class _BankingGroupMembersState extends State<BankingGroupMembers> {
  bool? approved;
  @override
  Widget build(BuildContext context) {
    var members = <BankingGroupMember>[];
    for (var element in widget.bankingGroup.members) {
      if (approved == null) {
        members.add(element);
      } else {
        if (element.approved == approved) {
          members.add(element);
        }
      }
    }
    return Column(
      children: [
        const Text('Members'),
        Column(
          children: members
              .map((e) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(e.username),
                    trailing: Text(e.investmentBalance.toString()),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
