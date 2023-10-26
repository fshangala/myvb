import 'package:flutter/material.dart';
import 'package:myvb/core/datatypes/banking_group_member.dart';
import 'package:myvb/core/datatypes/banking_group_transaction.dart';
import 'package:myvb/core/datatypes/model.dart';
import 'package:myvb/core/widgets/not_null_future_renderer.dart';

class VBGroupMemberTransactions extends StatefulWidget {
  final VBGroupMember member;
  const VBGroupMemberTransactions({super.key, required this.member});

  @override
  State<StatefulWidget> createState() {
    return _VBGroupMemberTransactions();
  }
}

class _VBGroupMemberTransactions extends State<VBGroupMemberTransactions> {
  late Future<List<VBGroupTransaction>> memberTransactions;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('My Transactions'),
        NotNullFutureRenderer(
            future: memberTransactions,
            futureRenderer: (transactions) {
              return Column(
                  children: transactions
                      .map((e) => ListTile(
                            title: Text(e.amount.toString()),
                            trailing: Text(e.approved.toString()),
                          ))
                      .toList());
            }),
        ListTile(
          title: const Text('Reload'),
          trailing: const Icon(Icons.repeat),
          onTap: () {
            setState(() {
              getTransactions();
            });
          },
        )
      ],
    );
  }

  void getTransactions() {
    memberTransactions = VBGroupTransaction().getObjects(QueryBuilder()
        .where('bankingGroupId', widget.member.bankingGroupId)
        .where('userId', widget.member.userId));
  }
}
